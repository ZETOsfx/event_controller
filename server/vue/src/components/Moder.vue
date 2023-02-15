<template>
  <div class="intro">
    <div class="container">
      <h6 class="text p-0 mt-4"> Управление отображением </h6>
      <!-- Подстилка - content -->
      <div class="content">

        <!-- Вкладки -->
        <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="pills-request-tab" data-bs-toggle="pill" data-bs-target="#pills-request" type="button" role="tab" aria-selected="true">Запросы на модерирование</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="pills-display-tab" data-bs-toggle="pill" data-bs-target="#pills-display" type="button" role="tab"  aria-selected="false">Активное отображение</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="pills-queue-tab" data-bs-toggle="pill" data-bs-target="#pills-queue" type="button" role="tab" aria-selected="false">Очередь отображения</button>
          </li>
          <!-- КОНЕЦ: Вкладки -->
        </ul>

        <!-- Содержимое вкладок -->
        <div class="tab-content" id="pills-tabContent">
          <!-- Входящие запросы на модерацю -->
          <div class="tab-pane fade show active" id="pills-request" role="tabpanel" aria-labelledby="pills-request-tab" tabindex="0">

            <ul class="list-group moder">
              <li v-for="(req, index) in this.reqList" class="list-group-item">
                <!-- Шаблон для будних дней -->
                <div v-if="!req.isspecial">
                  <div class="me-auto">
                    <div class="fw align-items-center">
                      <strong> {{ req.name }} </strong> <small>(отправлено: <i>@{{ req.author }}</i>)</small>
                    </div>
                    <small class="fw align-items-center"> {{ req.comment }} </small>
                  </div>
                  <div class="d-flex w-100 justify-content-between gap-1 mt-2">
                    <select class="form-select" aria-label="Default select example" disabled>
                      <option selected>Кафедра К3 - основной</option>
                      <!-- <option value="1">Кафедра К3 - новости</option> -->
                    </select>
                    <input id="startDate1" class="form-control" type="date" v-bind:value="req.date" disabled/>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Пары:
                    <select class="form-select form-select-sm w-75" disabled>
                      <option selected v-bind:value="req.lesson"> {{ req.lesson }} </option>
                      <option v-for="tmp in templatesToReplace" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Перерыв:
                    <select class="form-select form-select-sm w-75" disabled>
                      <option selected v-bind:value="req.breaktime"> {{ req.breaktime }} </option>
                      <option v-for="tmp in templatesToReplace" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Обед:
                    <select class="form-select form-select-sm w-75" disabled>
                      <option selected v-bind:value="req.lunch"> {{ req.lunch }} </option>
                      <option v-for="tmp in templatesToReplace" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                    <div class="form-check form-switch">
                      <input v-bind:value="req.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault2" disabled/>
                      <label class="form-check-label" for="flexSwitchCheckDefault2"> Особое расписание </label>
                    </div>
                    
                    <button v-if="!req.inProcessing && !this.reqList[index].isStartedProcess" @click="startProcess(index)" class="btn btn-outline-secondary">
                        Обработать
                    </button>
                    <div v-if="req.inProcessing && this.reqList[index].isStartedProcess" class="btn-group">
                      <button @click="endProcess(index)" type="button" class="btn btn-outline-secondary"> Завершить обработку </button>
                      <!-- Button trigger Details modal -->
                      <button type="button" class="btn btn-outline-info"  data-bs-toggle="modal" data-bs-target="#detailsWorkdaysModal">Просмотр</button>
                      <!-- Button trigger Deny modal -->
                      <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#denyModal"> Отклонить</button>
                      <!-- Button trigger Confirm modal -->
                      <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#confirmModal"> Утвердить </button>
                    </div>                    
                  </div>
                
                <!-- КОНЕЦ: Шаблон для будних дней -->
                </div>

                <!-- Шаблон дня по особому расписанию -->
                <div v-if="req.isspecial">
                  <div class="me-auto">
                    <div class="fw align-items-center">
                      <strong> {{ req.name }} </strong> <small>(отправлено: <i>@{{ req.author }}</i>)</small>
                    </div>
                    <small class="fw align-items-center">{{ req.comment }}</small>
                  </div>
                  <div class="d-flex w-100 justify-content-between gap-1 mt-2">
                    <select class="form-select" aria-label="Default select example" disabled>
                      <option selected>Кафедра К3 - основной</option>
                      <!-- <option value="1">Кафедра К3 - новостной</option>
                      <option value="2">Хол актового</option> -->
                    </select>
                    <input id="startDate2" class="form-control" type="date" v-bind:value="req.date" disabled/>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Шаблон:
                    <select class="form-select form-select-sm w-75" disabled>
                      <option selected v-bind:value="req.lesson"> {{ req.lesson }} </option>
                      <option v-for="tmp in templatesToReplace" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                    <div class="form-check form-switch">
                      <input v-bind:value="req.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault3" checked disabled/>
                      <label class="form-check-label" for="flexSwitchCheckDefault3"> Особое расписание </label>
                    </div>
                    
                    <button v-if="!req.inProcessing && !this.reqList[index].isStartedProcess" @click="startProcess(index)" class="btn btn-outline-secondary">
                      Обработать
                    </button>
                    <div v-if="req.inProcessing && this.reqList[index].isStartedProcess" class="btn-group">
                      <button @click="endProcess(index)" type="button" class="btn btn-outline-secondary"> Завершить обработку </button>
                      <!-- Button trigger Details modal -->
                      <button type="button" class="btn btn-outline-info"  data-bs-toggle="modal" data-bs-target="#detailsSpecialModal">Просмотр</button>
                      <!-- Button trigger Deny modal -->
                      <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#denyModal"> Отклонить</button>
                      <!-- Button trigger Confirm modal -->
                      <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#confirmModal"> Утвердить </button>
                    </div>              
                      
                  </div>
                  <!-- КОНЕЦ: Шаблон дня по особому расписанию -->
                </div>

                <!-- Modal for Details (WORKDAYS) -->
                <div class="modal fade" id="detailsWorkdaysModal" tabindex="-1" style="color:black">
                  <div class="modal-dialog modal-xl"> 
                      <div class="modal-content">
                          <div class="modal-header">
                              <h1 class="modal-title fs-5">Просмотр формы</h1>
                              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                          </div>
                          <div class="modal-body">
                              <!-- Вкладки -->
                              <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
                                  <li class="nav-item" role="presentation">
                                      <!-- Пары -->
                                      <button class="nav-link active" id="pills-lesson-tab" data-bs-toggle="pill" data-bs-target="#pills-lesson" type="button" role="tab" aria-selected="true">Пары</button>
                                  </li>
                                  <!-- Перерыв -->
                                  <li class="nav-item" role="presentation">
                                      <button class="nav-link" id="pills-break-tab" data-bs-toggle="pill" data-bs-target="#pills-break" type="button" role="tab"  aria-selected="false">Перерыв</button>
                                  </li>
                                  <!-- Обед -->
                                  <li class="nav-item" role="presentation">
                                      <button class="nav-link" id="pills-dinner-tab" data-bs-toggle="pill" data-bs-target="#pills-dinner" type="button" role="tab" aria-selected="false">Обед</button>
                                  </li>
                              </ul>

                              <!-- Содержимое вкладок -->
                              <div class="tab-content" id="pills-tabContent">
                                  <!-- Пары -->
                                  <div class="tab-pane fade show active" id="pills-lesson" role="tabpanel" tabindex="0"> 
                                      В последовательности на пары изменений нет.
                                  </div>
                                  <!-- Перерыв -->
                                  <div class="tab-pane fade show" id="pills-break" role="tabpanel" tabindex="0"> 
                                      В последовательности на перерыв изменений нет.
                                  </div>
                                  <!-- Обед -->
                                  <div class="tab-pane fade show" id="pills-dinner" role="tabpanel" tabindex="0"> 
                                      В последовательности на обед изменений нет.
                                  </div>
                              </div> 

                          </div>
                          <div class="modal-footer">
                              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                              <button type="button" class="btn btn-success">Сохранить</button>
                          </div>
                      </div>
                  </div>
                </div>
                <!-- Modal for Details (SPECIAL) -->
                <div class="modal fade" id="detailsSpecialModal" tabindex="-1">
                  <div class="modal-dialog modal-xl"> 
                      <div class="modal-content">
                          <div class="modal-header">
                              <h1 class="modal-title fs-5" id="exampleModalLabel">Просмотр формы</h1>
                              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                          </div>
                          <div class="modal-body">
                            - Особое расписание - 
                          </div>
                          <div class="modal-footer">
                              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                              <button type="button" class="btn btn-success">Сохранить</button>
                          </div>
                      </div>
                  </div>
                </div>
                <!-- Modal for Deny -->
                <div class="modal fade" id="denyModal" tabindex="-1">
                    <div class="modal-dialog">
                      <div class="modal-content">
                        <div class="modal-header">
                          <h1 class="modal-title fs-5" id="exampleModalLabela">Подтверждение</h1>
                          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                          Вы собираетесь отклонить "{{ req.name }}" <br> Вы уверены?
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                          <button @click="endProcess(req.name)" type="button" class="btn btn-danger">Отклонить</button>
                        </div>
                      </div>
                    </div>
                </div>
                <!-- Modal for Confirm -->
                <div class="modal fade" id="confirmModal" tabindex="-1">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabella">Подтверждение</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                      </div>
                      <div class="modal-body">
                        Вы собираетесь утвердить .текст. <br> Вы уверены?
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                        <button @click="endProcess(req.name)" type="button" class="btn btn-success">Утвердить</button>
                      </div>
                    </div>
                  </div>
                </div>

              </li>
            </ul>
            <!-- КОНЕЦ: Входящие запросы на модерацю -->
          </div>

          <!-- Что СЕЙЧАС отображается на экранах -->
          <div class="tab-pane fade" id="pills-display" role="tabpanel" aria-labelledby="pills-display-tab" tabindex="0">
            <ul class="list-group display">

              <!-- Шаблон для будних дней -->
              <li class="list-group-item">
                <select class="form-select">
                  <option selected>Кафедра К3 - основной</option>
                  <option value="1">Кафедра К3 - новости</option>
                  <option value="2">Хол актового</option>
                </select>
                <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                  Пары:
                  <select class="form-select form-select-sm w-75" >
                    <option selected>Пары (@admin)</option>
                    <option value="1">По умолчанию (web-forms)</option>
                    <option value="2">По умолчанию (новости)</option>
                  </select>
                </div>
                <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                  Перерыв:
                  <select class="form-select form-select-sm w-75">
                    <option selected>Перерыв_1 (@brigade5)</option>
                    <option value="1">По умолчанию (web-forms)</option>
                    <option value="2">По умолчанию (новости)</option>
                  </select>
                </div>
                <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                  Обед:
                  <select class="form-select form-select-sm w-75">
                    <option selected>Обед_2 (@brigade5)</option>
                    <option value="1">По умолчанию (web-forms)</option>
                    <option value="2">По умолчанию (новости)</option>
                  </select>
                </div>
                <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                  <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault4"/>
                    <label class="form-check-label" for="flexSwitchCheckDefault4"> Особое расписание </label>
                  </div>

                  <div>
                    <!-- Button trigger Delete follow modal -->
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteFollowModal"> Удалить из отслеживания</button>
                    <!-- Modal for Delete follow -->
                    <div class="modal fade" id="deleteFollowModal" tabindex="-1">
                      <div class="modal-dialog">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">Подтверждение</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                          </div>
                          <div class="modal-body">
                            Вы собираетесь удалить из отслеживания .текст. <br> Вы уверены?
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                            <button type="button" class="btn btn-danger">Удалить из отслеживания</button>
                          </div>
                        </div>
                      </div>
                    </div>
                    <button type="button" class="btn btn-outline-success">Применить изменения</button>
                  </div>
                </div>
                <!-- КОНЕЦ: Шаблон для будних дней -->
              </li>

              <!-- Шаблон дня по особому расписанию -->
              <li class="list-group-item">
                <select class="form-select">
                  <option selected>Кафедра К3 - новости</option>
                  <option value="1">Кафедра К3 - основной</option>
                  <option value="2">Хол актового</option>
                </select>
                <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                  Шаблон:
                  <select class="form-select form-select-sm w-75">
                    <option selected>По умолчанию (новости)</option>
                    <option value="1">По умолчанию (web-forms)</option>
                  </select>
                </div>
                <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                  <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault5" checked/>
                    <label class="form-check-label" for="flexSwitchCheckDefault5"> Особое расписание </label>
                  </div>
                  <div>
                    <!-- Button trigger Delete follow modal -->
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteFollowModal"> Удалить из отслеживания</button>
                    <!-- Modal for Delete follow -->
                    <!-- Сам код для Modal аходится выше, т.к. менюшка, по сути, тут одна -->
                    <button type="button" class="btn btn-outline-success">Применить изменения</button>
                  </div>
                </div>
                <!-- КОНЕЦ: Шаблон дня по особому расписанию -->
              </li>

            </ul>
            <div class="d-flex w-auto justify-content-start align-items-center gap-1 mt-2">
              <select class="form-select w-auto">
                <option selected>- Выберите -</option>
                <option value="1">Хол актового</option>
                <option value="2">Что-то ещё</option>
              </select>
              <div>
                <button type="button" class="btn btn-success">Добавить к ослеживанию</button>
              </div>
            </div>
            <!-- КОНЕЦ: Что СЕЙЧАС отображается на экранах -->
          </div>

          <!-- Очередь на отображение -->
          <div class="tab-pane fade" id="pills-queue" role="tabpanel" aria-labelledby="pills-queue-tab" tabindex="0">
            <ul class="list-group queue">
              <li v-for="(acc) in this.acceptedList" class="list-group-item d-flex justify-content-between align-items-center"> 
                <!-- Утвердили 3 шаблона на будни -->
                <div v-if="!acc.isspecial">
                  <div class="ms-2 me-auto">
                    <div class="fw align-items-center">
                      <strong>{{ acc.name }}</strong> <small>(Send: <i>@{{ acc.author }}</i>,  accepted: <i>@{{ acc.whoAccept }}</i>)</small>
                    </div>
                    <small class="fw align-items-center"> {{ acc.comment }} </small>

                    <div class="d-flex w-100 justify-content-between gap-1">
                      <select class="form-select" aria-label="Default select example" disabled>
                        <option selected>Кафедра К3 - основной</option>
                        <!-- <option value="1">Кафедра К3 - новости</option>
                        <option value="2">Хол актового</option> -->
                      </select>
                      <input id="startDate3" class="form-control" type="date" v-bind:value="acc.date" disabled/>
                    </div>
                    <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                      Пары:
                      <select class="form-select form-select-sm w-75" disabled>
                        <option selected v-bind:value="acc.lesson"> {{ acc.lesson }} </option>
                        <option v-for="tmp in templatesToReplace" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                      </select>
                    </div>
                    <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                      Перерыв:
                      <select class="form-select form-select-sm w-75" disabled>
                        <option selected v-bind:value="acc.lesson"> {{ acc.lesson }} </option>
                        <option v-for="tmp in templatesToReplace" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                      </select>
                    </div>
                    <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                      Обед:
                      <select class="form-select form-select-sm w-75" disabled>
                        <option selected v-bind:value="acc.lesson"> {{ acc.lesson }} </option>
                        <option v-for="tmp in templatesToReplace" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                      </select>
                    </div>
                    <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                      <div class="form-check form-switch">
                        <input v-bind:value="acc.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" disabled/>
                        <label class="form-check-label" for="flexSwitchCheckDefault"> Особое расписание </label>
                      </div>
                    </div>
                  </div>
                  <span class="badge">
                    <button name="id" type="submit" value="11" class="btn btn-outline-success btn-sm"> Изменить</button>
                    <button name="id" type="submit" value="11" class="btn btn-outline-danger btn-sm">Удалить</button>
                  </span>
                  <!-- КОНЕЦ: Утвердили 3 шаблона на будни -->
                </div>

                <!-- Утвердили шаблон по "особому расписанию" -->
                <div v-if="acc.isspecial">
                  <div class="ms-2 me-auto">
                    <div class="fw align-items-center">
                      <strong>{{ acc.name }}</strong> <small>(Send: <i>@{{ acc.author }}</i>,  accepted: <i>@{{ acc.whoAccept }}</i>)</small>
                    </div>
                    <small class="fw align-items-center"> {{ acc.comment }} </small>

                    <div class="d-flex w-100 justify-content-between gap-1">
                      <select class="form-select" aria-label="Default select example" disabled>
                        <option selected>Кафедра К3 - основной</option>
                        <!-- <option value="1">Кафедра К3 - новости</option>
                        <option value="2">Хол актового</option> -->
                      </select>
                      <input id="startDate" class="form-control" type="date" v-bind:value="acc.date" disabled/>
                    </div>
                    <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                      Шаблон:
                      <select class="form-select form-select-sm w-75" disabled>
                        <option selected v-bind:value="acc.lesson"> {{ acc.lesson }} </option>
                        <option v-for="tmp in templatesToReplace" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                      </select>
                    </div>
                    <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                      <div class="form-check form-switch">
                        <input v-bind:value="acc.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault1" disabled checked/>
                        <label class="form-check-label" for="flexSwitchCheckDefault1"> Особое расписание </label>
                      </div>
                    </div>
                  </div>
                  <span class="badge">
                    <button name="id" type="submit" value="11" class="btn btn-outline-success btn-sm"> Изменить</button>
                    <button name="id" type="submit" value="11" class="btn btn-outline-danger btn-sm">Удалить</button>
                  </span>
                  <!-- КОНЕЦ: Утвердили шаблон по "особому расписанию" -->
                </div>
              </li>
            </ul>
            <!-- КОНЕЦ: Очередь на отображение -->
          </div>
          <!-- КОНЕЦ: Содержимое вкладок -->
        </div>
        <!-- КОНЕЦ: Подстилка - content -->
      </div>
      <!-- КОНЕЦ: container -->
    </div>

    <!-- КОНЕЦ: intro -->
  </div>
</template>

<script>
export default {
  data() {
    return {
      allFormList: [],        // Все упакованные данные для модератора (heap data)
      acceptedList: [],       // Утвержденные на данный момент расписания <Request form> 
      reqList: [],            // Запросы редакторов на утверждение <Request form> 
      activeTmp: [],          // Шаблон, играющий прямо сейчас <Template form> 
      templatesToReplace: [], // Шаблоны на замену для корректировки и утверждения

      eventList: [],          // Список для событий открываемого шаблона
      

    }
  },
  methods: {
      // Возобновляемая дата (отсюда прилетает обработка)
    async getRequests() {
      await fetch(`/moder/`, {});
      let response = await fetch(`/moder/requests`, {
        method: 'GET',
          // THIS IS IMPORTANT
        headers: new Headers({
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*'
        })
      });
      this.allFormList = (await response.json());     // [ { ... , isAccess: true }, { ... , isAccess: false }, ... ]
      for (var i in this.allFormList) {
        if (this.allFormList[i].isAccepted === true) {
          this.acceptedList.push(this.allFormList[i]);
        } else {
          this.reqList.push(this.allFormList[i]);
        }
      }
        // Собственные шаблоны и уже проверенные
      let tmps = await fetch(`/moder/alltmp`, {});
      this.templatesToReplace = (await tmps.json());
    },
    async getActive() {   // Активная программа трансляции
      let response = await fetch(`/moder/active`, {});
      this.activeTmp = (await response.json());
    },
    async switchProcess(name) { 
      let responce = await fetch(`/moder/switchprocess`, this.options('PATCH', { name: name }));
    },
    async startProcess(index) {
      this.reqList[index].isStartedProcess = true;
      let name = this.reqList[index].name; 
      this.switchProcess(name);
    },
    async endProcess(index) {
      this.reqList[index].isStartedProcess = false;
      let name = this.reqList[index].name; 
      this.switchProcess(name);
    },


    options(method, body) {
      return {
        method: method,
        headers: {
          'Content-type': 'application/json; charset=UTF-8' // Indicates the content
        },
        body: JSON.stringify(body),
      }
    },
  },
  mounted() {
    this.getRequests();
  }
}
</script>