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
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="pills-preview-tab" data-bs-toggle="pill" data-bs-target="#pills-preview" type="button" role="tab" aria-selected="false" disabled>Подробный просмотр</button>
          </li>
          <!-- КОНЕЦ: Вкладки -->
        </ul>

        <!-- Содержимое вкладок -->
        <div class="tab-content" id="pills-tabContent">
          <!-- Входящие запросы на модерацю -->
          <div class="tab-pane fade show active" id="pills-request" role="tabpanel" aria-labelledby="pills-request-tab" tabindex="0">
            <ul class="list-group moder">

              <!-- Шаблон для будних дней -->
              <li class="list-group-item">
                <div class="ms-2 me-auto">
                  <div class="fw align-items-center">
                    <strong> Любой текст заголовка </strong> <small>(отправлено: <i>@brigade4</i>)</small>
                  </div>
                  <small class="fw align-items-center"> Небольшой комментарий от бригады</small>
                </div>
                <div class="d-flex w-100 justify-content-between gap-1">
                  <select class="form-select" aria-label="Default select example" disabled>
                    <option selected>Кафедра К3 - основной</option>
                    <option value="1">Кафедра К3 - новости</option>
                    <option value="2">Хол актового</option>
                  </select>
                  <input id="startDate" class="form-control" type="date" value="2023-02-03" disabled/>
                </div>
                <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                  Пары:
                  <select class="form-select form-select-sm w-75" disabled>
                    <option selected>- Нет изменений -</option>
                    <option value="1">По умолчанию (web-forms)</option>
                    <option value="2">По умолчанию (новости)</option>
                  </select>
                </div>
                <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                  Перерыв:
                  <select class="form-select form-select-sm w-75" disabled>
                    <option selected>Перерыв_1 (@brigade4)</option>
                    <option value="1">По умолчанию (web-forms)</option>
                    <option value="2">По умолчанию (новости)</option>
                  </select>
                </div>
                <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                  Обед:
                  <select class="form-select form-select-sm w-75" disabled>
                    <option selected>Обед_2 (@brigade4)</option>
                    <option value="1">По умолчанию (web-forms)</option>
                    <option value="2">По умолчанию (новости)</option>
                  </select>
                </div>
                <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                  <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" disabled/>
                    <label class="form-check-label" for="flexSwitchCheckDefault"> Особое расписание </label>
                  </div>
                  <div>
                    <button type="button" class="btn btn-outline-secondary">Подробнее</button>
                    <!-- Button trigger Deny modal -->
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#denyModal"> Отклонить</button>
                    <!-- Modal for Deny -->
                    <div class="modal fade" id="denyModal" tabindex="-1" style="color:black">
                      <div class="modal-dialog">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">Подтверждение</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                          </div>
                          <div class="modal-body">
                            Вы собираетесь отклонить .текст. <br> Вы уверены?
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                            <button type="button" class="btn btn-danger">Отклонить</button>
                          </div>
                        </div>
                      </div>
                    </div>
                    <!-- Button trigger Confirm modal -->
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#confirmModal"> Утвердить </button>
                    <!-- Modal for Confirm -->
                    <div class="modal fade" id="confirmModal" tabindex="-1" style="color:black">
                      <div class="modal-dialog">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">Подтверждение</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                          </div>
                          <div class="modal-body">
                            Вы собираетесь утвердить .текст. <br> Вы уверены?
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                            <button type="button" class="btn btn-success">Утвердить</button>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- КОНЕЦ: Шаблон для будних дней -->
              </li>

              <!-- Шаблон дня по особому расписанию -->
              <li class="list-group-item">
                <div class="ms-2 me-auto">
                  <div class="fw align-items-center">
                    <strong> Любой текст заголовка </strong> <small>(отправлено: <i>@brigade4</i>)</small>
                  </div>
                  <small class="fw align-items-center"> Небольшой комментарий от бригады</small>
                </div>
                <div class="d-flex w-100 justify-content-between gap-1">
                  <select class="form-select" aria-label="Default select example" disabled>
                    <option selected>Кафедра К3 - новости</option>
                    <option value="1">Кафедра К3 - основной</option>
                    <option value="2">Хол актового</option>
                  </select>
                  <input id="startDate" class="form-control" type="date" value="2023-02-04" disabled/>
                </div>
                <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                  Шаблон:
                  <select class="form-select form-select-sm w-75" disabled>
                    <option selected>По умолчанию (новости)</option>
                    <option value="1">По умолчанию (web-forms)</option>
                  </select>
                </div>
                <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                  <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" checked disabled/>
                    <label class="form-check-label" for="flexSwitchCheckDefault"> Особое расписание </label>
                  </div>
                  <div>
                    <button type="button" class="btn btn-outline-secondary">Подробнее</button>
                    <!-- Button trigger Deny modal -->
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#denyModal"> Отклонить</button>
                    <!-- Button trigger Confirm modal -->
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#confirmModal"> Утвердить </button>
                    <!-- Сам код для Modal аходится выше, т.к. менюшка, по сути, тут одна -->
                  </div>
                </div>
                <!-- КОНЕЦ: Шаблон дня по особому расписанию -->
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
                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault"/>
                    <label class="form-check-label" for="flexSwitchCheckDefault"> Особое расписание </label>
                  </div>

                  <div>
                    <!-- Button trigger Delete follow modal -->
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteFollowModal"> Удалить из отслеживания</button>
                    <!-- Modal for Delete follow -->
                    <div class="modal fade" id="deleteFollowModal" tabindex="-1" style="color:black">
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
                    <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" checked/>
                    <label class="form-check-label" for="flexSwitchCheckDefault"> Особое расписание </label>
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

              <!-- Утвердили 3 шаблона на будни -->
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <div class="ms-2 me-auto">
                  <div class="fw align-items-center">
                    <strong> Любой текст заголовка </strong> <small>(Send: <i>@brigade3</i>,  accepted: <i>@admin</i>)</small>
                  </div>
                  <small class="fw align-items-center"> Небольшой комментарий от бригады или модератора (ещё хз) </small>

                  <div class="d-flex w-100 justify-content-between gap-1">
                    <select class="form-select" aria-label="Default select example" disabled>
                      <option selected>Кафедра К3 - основной</option>
                      <option value="1">Кафедра К3 - новости</option>
                      <option value="2">Хол актового</option>
                    </select>
                    <input id="startDate" class="form-control" type="date" value="2023-02-03" disabled/>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Пары:
                    <select class="form-select form-select-sm w-75" disabled>
                      <option selected>- Нет изменений -</option>
                      <option value="1">По умолчанию (web-forms)</option>
                      <option value="2">По умолчанию (новости)</option>
                    </select>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Перерыв:
                    <select class="form-select form-select-sm w-75" disabled>
                      <option selected>Перерыв_1 (@brigade4)</option>
                      <option value="1">По умолчанию (web-forms)</option>
                      <option value="2">По умолчанию (новости)</option>
                    </select>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Обед:
                    <select class="form-select form-select-sm w-75" disabled>
                      <option selected>Обед_2 (@brigade4)</option>
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
                </div>
                <span class="badge">
                                    <button name="id" type="submit" value="11" class="btn btn-outline-success btn-sm"> Изменить</button>
                                    <button name="id" type="submit" value="11" class="btn btn-outline-danger btn-sm">Удалить</button>
                                </span>
                <!-- КОНЕЦ: Утвердили 3 шаблона на будни -->
              </li>

              <!-- Утвердили шаблон по "особому расписанию" -->
              <li class="list-group-item d-flex justify-content-between align-items-center">
                <div class="ms-2 me-auto">
                  <div class="fw align-items-center">
                    <strong> На субботу </strong> <small>(Send: <i>@brigade4</i>,  accepted: <i>@admin</i>)</small>
                  </div>
                  <small class="fw align-items-center"> Небольшой комментарий от бригады или модератора (ещё хз) </small>

                  <div class="d-flex w-100 justify-content-between gap-1">
                    <select class="form-select" aria-label="Default select example" disabled>
                      <option selected>Кафедра К3 - основной</option>
                      <option value="1">Кафедра К3 - новости</option>
                      <option value="2">Хол актового</option>
                    </select>
                    <input id="startDate" class="form-control" type="date" value="2023-02-04" disabled/>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Шаблон:
                    <select class="form-select form-select-sm w-75" disabled>
                      <option selected>Новости (изм.) </option>
                      <option value="1">По умолчанию (web-forms)</option>
                      <option value="2">По умолчанию (новости)</option>
                    </select>
                  </div>
                  <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                    <div class="form-check form-switch">
                      <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" disabled checked/>
                      <label class="form-check-label" for="flexSwitchCheckDefault"> Особое расписание </label>
                    </div>
                  </div>
                </div>
                <span class="badge">
                                    <button name="id" type="submit" value="11" class="btn btn-outline-success btn-sm"> Изменить</button>
                                    <button name="id" type="submit" value="11" class="btn btn-outline-danger btn-sm">Удалить</button>
                                </span>
                <!-- КОНЕЦ: Утвердили шаблон по "особому расписанию" -->
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
      allFormList: [],      // Все упакованные данные для модератора 
      acceptedList: [],     // Утвержденные на данный момент расписания (в очереди на воспроизведение)
      reqList: [],          // Запросы редакторов на утверждение
      


    }
  },
  methods: {
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
      this.allFormList = (await response.json());
      for (var i in this.allFormList) {
        if (this.allFormList[i].isAccepted === true) {
          this.acceptedList.push(this.allFormList[i]);
        } else {
          this.reqList.push(this.allFormList[i]);
        }
      }
    },

  },
  mounted() {
    this.getRequests();
  }
}
</script>