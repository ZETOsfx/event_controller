<template>
  <div class="intro">
    <div class="container">
      <h6 class="text p-0 mt-4"> Управление отображением </h6>
      <!-- Подстилка - content -->
      <div class="content">

        <!-- ЗАГОЛОВКИ ВКЛАДОК -->
        <ul class="nav nav-pills mb-3" id="pills-tab1" role="tablist">
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
        <div class="tab-content" id="pills-tabContent1">

          <!-- Группировка toasts -->
          <div class="toast-container bottom-0 end-0 p-3">
            <!-- Успешно -->
            <div class="toast fade text-bg-success" role="alert" id="ToastSuccess" aria-live="assertive" aria-atomic="true" data-bs-delay="10000">
              <div class="toast-header">
                <rect width="100%" height="100%" fill="#007aff"></rect>
                <strong class="me-auto">Успешно!</strong>
                <small class="text-muted"> {{ this.currentTime }} </small>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
              </div>
              <div class="toast-body">
                {{ this.successMessage }}
              </div>
            </div>

            <!-- Ошибка -->
            <div class="toast fade text-bg-danger" role="alert" id="ToastError" aria-live="assertive" aria-atomic="true" data-bs-delay="10000">
              <div class="toast-header">
                <rect width="100%" height="100%" fill="#007aff"></rect>
                <strong class="me-auto">Произошла ошибка!</strong>
                <small class="text-muted"> {{ this.currentTime }} </small>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
              </div>
              <div class="toast-body">
                {{ this.errorMessage }}
              </div>
            </div>

            <!-- Инфо -->
            <div class="toast fade text-bg-info" role="alert" id="ToastInfo" aria-live="assertive" aria-atomic="true" data-bs-delay="10000">
              <div class="toast-header">
                <rect width="100%" height="100%" fill="#007aff"></rect>
                <strong class="me-auto">Уведомление</strong>
                <small class="text-muted">20:07</small>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
              </div>
              <div class="toast-body">
                Шаблон <i>"название"</i> одобрен модератором <i>Имя Модератора</i>
              </div>
            </div>
          </div>

          <!-- ВХОДЯЩИЕ ЗАРОСЫ НА МОДЕРАЦИЮ -->
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

                    <!--КНОПКИ ОБРАБОТКИ СОБЫТИЯ-->
                    <button v-if="!req.isStartedProcess" @click="startProcess(index)" class="btn btn-outline-secondary">
                        Обработать
                    </button>
                    <div v-if="req.isStartedProcess && (this.userProcess === req.name || req.whoAccept === this.username.name)" class="btn-group">
                      <button @click="endProcess(index)" type="button" class="btn btn-outline-secondary"> Завершить обработку </button>
                      <!-- Button trigger Details modal -->
                      <button type="button" class="btn btn-outline-info"  data-bs-toggle="modal" data-bs-target="#detailsWorkdaysModal">Просмотр</button>
                      <!-- Button trigger Deny modal -->
                      <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#denyModal"> Отклонить</button>
                      <!-- Button trigger Confirm modal -->
                      <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#confirmModal"> Утвердить </button>
                    </div>
                    <div v-if="req.isStartedProcess && req.whoAccept !== this.username.name">
                      Событие находится в обработке: @{{ req.whoAccept }}
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
                    
                    <!--КНОПКИ ОБРАБОТКИ СОБЫТИЯ-->
                    <button v-if="!req.isStartedProcess" @click="startProcess(index)" class="btn btn-outline-secondary">
                        Обработать
                    </button>
                    <div v-if="req.isStartedProcess && (this.userProcess === req.name || req.whoAccept === username)" class="btn-group">
                      <button @click="endProcess(index)" type="button" class="btn btn-outline-secondary"> Завершить обработку </button>
                      <!-- Button trigger Details modal -->
                      <button type="button" class="btn btn-outline-info"  data-bs-toggle="modal" data-bs-target="#detailsModal">Просмотр</button>
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
                              <h1 class="modal-title fs-5" id="exampleModalLabel1">Просмотр формы</h1>
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

          <!-- АКТИВНОЕ ОТОБРАЖЕНИЕ (ЧТО ИГРАЕТ СЕГОДНЯ) -->
          <div class="tab-pane fade" id="pills-display" role="tabpanel" aria-labelledby="pills-display-tab" tabindex="0">

            <div class="row">
              <div class="col-sm-4 mb-3">
                
                <div class="card h-100">
                  <div class="card-header">
                    <h5 class="card-title m-0"> Кафедра К3 - основной</h5>
                  </div>
                  <div class="card-body">
                    <div class="progress" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                      <div class="progress-bar progress-bar-striped bg-success progress-bar-animated" id="progress1"> </div>
                    </div>
                    <div id="time"></div>
                    <ul class="list-group display mt-1">
                    <!-- Шаблон для будних дней -->
                    <li class="list-group-item">
                        <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                            Пары:
                            <select class="form-select form-select-sm w-75" disabled>
                                <option selected>Пары (@admin)</option>
                                <option value="1">По умолчанию (web-forms)</option>
                                <option value="2">По умолчанию (новости)</option>
                            </select>
                        </div>
                        <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                            Перерыв:
                            <select class="form-select form-select-sm w-75" disabled>
                                <option selected>Перерыв_1 (@brigade5)</option>
                                <option value="1">По умолчанию (web-forms)</option>
                                <option value="2">По умолчанию (новости)</option>
                            </select>
                        </div>
                        <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                            Обед:
                            <select class="form-select form-select-sm w-75" disabled>
                                <option selected>Обед_2 (@brigade5)</option>
                                <option value="1">По умолчанию (web-forms)</option>
                                <option value="2">По умолчанию (новости)</option>
                            </select>
                        </div>
                        <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" disabled/>
                                <label class="form-check-label" for="flexSwitchCheckDefault"> Особое расписание </label>
                            </div>
                        </div>
                    <!-- КОНЕЦ: Шаблон для будних дней -->
                    </li>
                  </ul>
                  </div>
                  <div class="card-footer text-end">
                    <div class="d-flex w-100 justify-content-between align-items-center">
                      <!-- Button trigger Delete follow modal -->
                      <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteFollowModal"> Удалить из отслеживания</button>
                      <button type="button" class="btn btn-outline-success">Редактировать</button>
                    </div>
                  </div>
                </div>
                
              </div>
            </div>
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

          <!-- ОЧЕРЕДЬ ШАБЛОНОВ НА ОТОБРАЖЕНИЕ (УЖЕ УТВЕРЖДЕННЫЕ)  -->
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
      userProcess: '',        // Имя события, которое на данный момент обрабатывает модератор

      succCallback: [],       // Колбек - успешно
      errCallback: [],        // Колбек - ошибка

      successMessage: null,   // Текст успешной операции
      errorMessage: null,     // Текст ошибки

      currentTime: null,      // Текущее время
      username: ''
    }
  },
  methods: {
    async ProgressBar() {
      let Lessons = [ 
        [28800, 31200, 'Перерыв'], // Перерыв до пар
        [31200, 36900, '1-ая пара'], // 1ая пара
        [36900, 37500, 'Перерыв'], // Перерыв
        [37500, 37500, '2-ая пара'], // 2ая пара
        [43200, 46200, 'Обед'], // Обед
        [46200, 51900, '3-ая пара'], // 3ая пара
        [51900, 52500, 'Перерыв'], // Перерыв
        [52500, 58200, '4-ая пара'], // 4ая пара
        [58200, 58800, 'Перерыв'], // Перерыв
        [58800, 64500, '5-ая пара'], // 5ая пара
        [64500, 64800, 'Перерыв'], // Перерыв
        [64800, 70500, '6-ая пара'], // 6ая пара
      ]

      function getProcent(curSec) {
        for (let i in Lessons)
          if (curSec >= Lessons[i][0] && curSec < Lessons[i][1]) {
            let during = Lessons[i][1] - Lessons[i][0];
            let fromStart = Lessons[i][1] - curSec;
            let procent = 100 - fromStart * 100 / during;
            return [procent, Lessons[i][2]]
          }
        // Свободное время
        return [100, 'Свободное время']
      }

      function checkTime(i) {
        if (i < 10) {
        i = "0" + i;
        }
        return i;
      }

      function startTime() {
        var today = new Date();
        var h = today.getHours();
        var m = today.getMinutes();
        var s = today.getSeconds();

        curSec = (h * 60 + m) * 60 + s;
        procent = getProcent(curSec)[0] + "%";
        name1 = getProcent(curSec)[1];

        // add a zero in front of numbers<10
        h = checkTime(h);
        m = checkTime(m);
        s = checkTime(s);
        actualTime = h + ":" + m + ":" + s + " - " + name1;

        document.getElementById('time').innerHTML = actualTime;
        document.getElementById("progress1").style["width"] = procent;

        

        t = setTimeout(function() {
          startTime()
        }, 1000);
      }
      startTime();
    },
      // Получить время
    async getTime() {
      // Дата - время коллбека
      let date_ob = new Date();
      let hour = date_ob.getHours();
      if (hour < 10) hour = "0" + hour;
      let min = date_ob.getMinutes();
      if (min < 10) min = "0" + min;
      let sec = date_ob.getSeconds();
      if (sec < 10) sec = "0" + sec;
      this.currentTime = hour + ':' + min + ':' + sec;
    },
      // Возобновляемая дата (отсюда прилетает обработка)
    async getRequests() {
      this.succCallback = new bootstrap.Toast(document.getElementById("ToastSuccess"));
      this.errCallback = new bootstrap.Toast(document.getElementById("ToastError"));

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
      for (let i in this.allFormList) {
        if (this.allFormList[i].isAccepted === true) {
          this.acceptedList.push(this.allFormList[i]);
        } else {
          this.reqList.push(this.allFormList[i]);
        }

        if (this.reqList[i].inProcessing) {
          this.reqList[i].isStartedProcess = true;
          if (this.reqList[i].whoAccept === this.username.name) {
            this.userProcess = this.reqList[i].name;
          }
        }
      }
        // Собственные шаблоны и уже проверенные
      let templates = await fetch(`/moder/alltmp`, {});
      this.templatesToReplace = (await templates.json());
    },
      // Активная программа трансляции
    async getActive() {
      let response = await fetch(`/moder/active`, {});
      this.activeTmp = (await response.json());
    },
      // Переключение процесса обработки собитя <NAME> на противоположный
    async switchProcess(name) { 
      let response = await fetch(`/moder/switchprocess`, this.options('PATCH', { name: name }));
      console.log(response);
    },
      // Начать процесс обработки
    async startProcess(index) {
      await this.getTime();
      if (this.userProcess === '') {
        this.reqList[index].isStartedProcess = true;
        let name = this.reqList[index].name;
        await this.switchProcess(name);
        this.userProcess = name;
      } else {
          // Процесс обработки уже начат
        this.errorMessage = 'Вы можете обрабатывать максимум одно событие! Сначала завершите текущую обработку.';
        this.errCallback.show();
      }
    },
      // Завершить процесс обработки
    async endProcess(index) {
      this.reqList[index].isStartedProcess = false;
      let name = this.reqList[index].name; 
      await this.switchProcess(name);
      this.userProcess = '';
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
      // Действие при загрузке страницы
  mounted() {
    this.getRequests(); // Получение списка всех запросов для последующей отрисовки
    this.username = window.user;
    this.ProgressBar(); // Запускаем бесконечную залупу
  } 
}

</script>