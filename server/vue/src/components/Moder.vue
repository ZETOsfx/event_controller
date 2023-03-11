<template>
  <div class="intro">

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


    <!--ГРУППИРОВКА - МОДАЛКИ-->

    <!-- Modal for Details (WORKDAYS) -->
    <div class="modal fade" id="detailsWorkdaysModal" tabindex="-1" data-bs-backdrop="static">
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
            <div v-if="this.eventList.data" class="tab-content" id="pills-tabContent">
              <!-- Пары -->
              <div class="tab-pane fade show active" id="pills-lesson" role="tabpanel" tabindex="0">
                <div v-if="this.eventList.data.lesson === '-'">
                  В последовательности на пары изменений нет.
                </div>
                <div v-if="this.eventList.data.lesson !== '-'">
                  <div v-for="(event, index) in this.eventList.data.lesson" class="row gx-3 gy-2 align-items-center p-1">
                    <div v-if="!editFormS[index].isDeleted" class="col-sm-3">
                      <label class="visually-hidden" for="specificSizeInputName1">Name</label>
                      <input v-model="event.name" type="text" class="form-control" id="specificSizeInputName1" placeholder="Имя"
                             :disabled="editFormS[index].isDisabled">
                    </div>
                    <div v-if="!editFormS[index].isDeleted" class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeInputGroupUsername1">Username</label>
                      <input v-model="event.src" type="text" class="form-control" id="specificSizeInputGroupUsername1"
                             placeholder="Ссылка" :disabled="editFormS[index].isDisabled">
                    </div>
                    <div v-if="!editFormS[index].isDeleted" class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                      <select v-model="event.type" class="form-select" id="specificSizeSelect" :disabled="editFormS[index].isDisabled">
                        <option value="0">Изображение</option>
                        <option value="1">WEB-форма</option>
                        <option value="2">Видео</option>
                      </select>
                    </div>
                    <div v-if="!editFormS[index].isDeleted" class="col-sm-1">
                      <label class="visually-hidden" for="specificSizeInputGroupUsername2">Username</label>
                      <input v-model="event.time" type="number" class="form-control" id="specificSizeInputGroupUsername2" placeholder="Время в сек" :disabled="this.editFormS[index].isDisabled">
                    </div>

                    <div v-if="!editFormS[index].isDeleted" class="col-auto">
                      <button v-if="!editFormS[index].isDeleted && editFormS[index].isDisabled" @click="editEvent(index, this.editFormS)" class="btn btn-secondary">
                        Редактировать
                      </button>
                      <template v-if="!editFormS[index].isDisabled">
                        <button @click="saveEvent(index, this.editFormS)" class="btn btn-secondary"> Сохранить </button>
                        <button @click="delEvent(index, this.editFormS, this.eventList.data.lesson)" class="btn btn-outline-danger ms-1"> Удалить </button>
                      </template>
                    </div>
                    <div v-if="!editFormS[index].isDeleted && editFormS[index].isDisabled" class="col-auto">
                      <button @click="moveEvent('up', index, this.eventList.data.lesson)" class="btn btn-outline-warning"><i class="fa-solid fa-up"></i></button>
                    </div>
                    <div v-if="!editFormS[index].isDeleted && editFormS[index].isDisabled" class="col-auto">
                      <button @click="moveEvent('down', index, this.eventList.data.lesson)" class="btn btn-outline-warning"><i class="fa-solid fa-down"></i></button>
                    </div>
                  </div>
                  <!--ФОРМА ДОБАВЛЕНИЯ!!!!!!!!!-->
                  <div class="row gx-3 gy-2 align-items-center p-1">
                    <div class="col-sm-3">
                      <label class="visually-hidden" for="specificSizeInputNameOfLol">Name</label>
                      <input v-model="addForm.name" type="text" class="form-control" id="specificSizeInputNameOfLol" placeholder="Имя" required>
                    </div>

                    <!--            &lt;!&ndash;@change="onFileChange"&ndash;&gt;-->
                    <!--          <div v-if="Number(addForm.type) === 0 || Number(addForm.type) === 2" class="col-sm-2">-->
                    <!--            <input class="form-control" type="file" id="fileName" ref="file">-->
                    <!--          </div>-->

                    <!--          v-if="Number(addForm.type) === 1"-->
                    <div class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeInputGroupUserDebi4">Username</label>
                      <input v-model="addForm.src" type="text" class="form-control" id="specificSizeInputGroupUserDebi4" placeholder="Ссылка" required>
                    </div>

                    <div class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                      <select v-model="addForm.type" class="form-select" id="specificSizeSelect">
                        <option value="0" selected>Изображение</option>
                        <option value="1">WEB-форма</option>
                        <option value="2">Видео</option>
                      </select>
                    </div>

                    <div class="col-sm-1">
                      <label class="visually-hidden" for="specificSizeInputGroupUserkek">Username</label>
                      <input v-model="addForm.time" type="number" class="form-control" id="specificSizeInputGroupUserkek" placeholder="Время в сек" required>
                    </div>

                    <div class="col-auto">
                      <button @click="addEvent(this.editFormS, this.eventList.data.lesson)" type="submit" class="btn btn-success">Добавить</button>
                    </div>

                  </div>
                </div>
              </div>

              <!-- Перерыв -->
              <div class="tab-pane fade show" id="pills-break" role="tabpanel" tabindex="0">
                <div v-if="this.eventList.data.breaktime === 'lesson'">
                  На этот пункт установлен шаблон, аналогичный представленному во вкладке "Пары".
                </div>
                <div v-if="this.eventList.data.breaktime !== 'lesson'">
                  <div v-for="(event, index) in this.eventList.data.breaktime" class="row gx-3 gy-2 align-items-center p-1">
                    <div v-if="!editFormB[index].isDeleted" class="col-sm-3">
                      <label class="visually-hidden" for="specificSizeInputName2">Name</label>
                      <input v-model="event.name" type="text" class="form-control" id="specificSizeInputName2" placeholder="Имя"
                             :disabled="editFormB[index].isDisabled">
                    </div>
                    <div v-if="!editFormB[index].isDeleted" class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeInputGroupUsername4">Username</label>
                      <input v-model="event.src" type="text" class="form-control" id="specificSizeInputGroupUsername4"
                             placeholder="Ссылка" :disabled="editFormB[index].isDisabled">
                    </div>
                    <div v-if="!editFormB[index].isDeleted" class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                      <select v-model="event.type" class="form-select" id="specificSizeSelect" :disabled="editFormB[index].isDisabled">
                        <option value="0">Изображение</option>
                        <option value="1">WEB-форма</option>
                        <option value="2">Видео</option>
                      </select>
                    </div>
                    <div v-if="!editFormB[index].isDeleted" class="col-sm-1">
                      <label class="visually-hidden" for="specificSizeInputGroupUsername3">Username</label>
                      <input v-model="event.time" type="number" class="form-control" id="specificSizeInputGroupUsername3" placeholder="Время в сек" :disabled="this.editFormB[index].isDisabled">
                    </div>

                    <div v-if="!editFormB[index].isDeleted" class="col-auto">
                      <button v-if="!editFormB[index].isDeleted && editFormB[index].isDisabled" @click="editEvent(index, this.editFormB)" class="btn btn-secondary">
                        Редактировать
                      </button>
                      <template v-if="!editFormB[index].isDisabled">
                        <button @click="saveEvent(index, this.editFormB)" class="btn btn-secondary"> Сохранить </button>
                        <button @click="delEvent(index, this.editFormB, this.eventList.data.breaktime)" class="btn btn-outline-danger ms-1"> Удалить </button>
                      </template>
                    </div>
                    <div v-if="!editFormB[index].isDeleted && editFormB[index].isDisabled" class="col-auto">
                      <button @click="moveEvent('up', index, this.eventList.data.breaktime)" class="btn btn-outline-warning"><i class="fa-solid fa-up"></i></button>
                    </div>
                    <div v-if="!editFormB[index].isDeleted && editFormB[index].isDisabled" class="col-auto">
                      <button @click="moveEvent('down', index, this.eventList.data.breaktime)" class="btn btn-outline-warning"><i class="fa-solid fa-down"></i></button>
                    </div>
                  </div>
                  <!--ФОРМА ДОБАВЛЕНИЯ!!!!!!!!!-->
                  <div class="row gx-3 gy-2 align-items-center p-1">
                    <div class="col-sm-3">
                      <label class="visually-hidden" for="specificSizeInputNeName">Name</label>
                      <input v-model="addForm.name" type="text" class="form-control" id="specificSizeInputNeName" placeholder="Имя" required>
                    </div>

                    <!--            &lt;!&ndash;@change="onFileChange"&ndash;&gt;-->
                    <!--          <div v-if="Number(addForm.type) === 0 || Number(addForm.type) === 2" class="col-sm-2">-->
                    <!--            <input class="form-control" type="file" id="fileName" ref="file">-->
                    <!--          </div>-->

                    <!--          v-if="Number(addForm.type) === 1"-->
                    <div class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeInputGroupUserDebil">Username</label>
                      <input v-model="addForm.src" type="text" class="form-control" id="specificSizeInputGroupUserDebil" placeholder="Ссылка" required>
                    </div>

                    <div class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                      <select v-model="addForm.type" class="form-select" id="specificSizeSelect">
                        <option value="0" selected>Изображение</option>
                        <option value="1">WEB-форма</option>
                        <option value="2">Видео</option>
                      </select>
                    </div>

                    <div class="col-sm-1">
                      <label class="visually-hidden" for="specificSizeInputGroupAbuser">Username</label>
                      <input v-model="addForm.time" type="number" class="form-control" id="specificSizeInputGroupAbuser" placeholder="Время в сек" required>
                    </div>

                    <div class="col-auto">
                      <button @click="addEvent(this.editFormB, this.eventList.data.breaktime)" type="submit" class="btn btn-success">Добавить</button>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Обед -->
              <div class="tab-pane fade show" id="pills-dinner" role="tabpanel" tabindex="0">
                <div v-if="this.eventList.data.lunch === 'lesson'">
                  На этот пункт установлен шаблон, аналогичный представленному во вкладке "Пары".
                </div>
                <div v-if="this.eventList.data.lunch === 'breaktime'">
                  На этот пункт установлен шаблон, аналогичный представленному во вкладке "Перерыв".
                </div>
                <div v-if="this.eventList.data.lunch !== 'lesson' && this.eventList.data.lunch !== 'breaktime'">
                  <div v-for="(event, index) in this.eventList.data.lunch" class="row gx-3 gy-2 align-items-center p-1">
                    <div v-if="!editFormL[index].isDeleted" class="col-sm-3">
                      <label class="visually-hidden" for="specificSizeInputName8">Name</label>
                      <input v-model="event.name" type="text" class="form-control" id="specificSizeInputName8" placeholder="Имя"
                             :disabled="editFormL[index].isDisabled">
                    </div>
                    <div v-if="!editFormL[index].isDeleted" class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeInputGroupUsername9">Username</label>
                      <input v-model="event.src" type="text" class="form-control" id="specificSizeInputGroupUsername9"
                             placeholder="Ссылка" :disabled="editFormL[index].isDisabled">
                    </div>
                    <div v-if="!editFormL[index].isDeleted" class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                      <select v-model="event.type" class="form-select" id="specificSizeSelect" :disabled="editFormL[index].isDisabled">
                        <option value="0">Изображение</option>
                        <option value="1">WEB-форма</option>
                        <option value="2">Видео</option>
                      </select>
                    </div>
                    <div v-if="!editFormL[index].isDeleted" class="col-sm-1">
                      <label class="visually-hidden" for="specificSizeInputGroupUsername100">Username</label>
                      <input v-model="event.time" type="number" class="form-control" id="specificSizeInputGroupUsername100" placeholder="Время в сек" :disabled="this.editFormL[index].isDisabled">
                    </div>

                    <div v-if="!editFormL[index].isDeleted" class="col-auto">
                      <button v-if="!editFormL[index].isDeleted && editFormL[index].isDisabled" @click="editEvent(index, this.editFormL)" class="btn btn-secondary">
                        Редактировать
                      </button>
                      <template v-if="!editFormL[index].isDisabled">
                        <button @click="saveEvent(index, this.editFormL)" class="btn btn-secondary"> Сохранить </button>
                        <button @click="delEvent(index, this.editFormL, this.eventList.data.lunch)" class="btn btn-outline-danger ms-1"> Удалить </button>
                      </template>
                    </div>
                    <div v-if="!editFormL[index].isDeleted && editFormL[index].isDisabled" class="col-auto">
                      <button @click="moveEvent('up', index, this.eventList.data.lunch)" class="btn btn-outline-warning"><i class="fa-solid fa-up"></i></button>
                    </div>
                    <div v-if="!editFormL[index].isDeleted && editFormL[index].isDisabled" class="col-auto">
                      <button @click="moveEvent('down', index, this.eventList.data.lunch)" class="btn btn-outline-warning"><i class="fa-solid fa-down"></i></button>
                    </div>
                  </div>
                  <!--ФОРМА ДОБАВЛЕНИЯ!!!!!!!!!-->
                  <div class="row gx-3 gy-2 align-items-center p-1">
                    <div class="col-sm-3">
                      <label class="visually-hidden" for="specificSizeInputName">Name</label>
                      <input v-model="addForm.name" type="text" class="form-control" id="specificSizeInputName" placeholder="Имя" required>
                    </div>

                    <!--            &lt;!&ndash;@change="onFileChange"&ndash;&gt;-->
                    <!--          <div v-if="Number(addForm.type) === 0 || Number(addForm.type) === 2" class="col-sm-2">-->
                    <!--            <input class="form-control" type="file" id="fileName" ref="file">-->
                    <!--          </div>-->

                    <!--          v-if="Number(addForm.type) === 1"-->
                    <div class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeInputGroupUserDebian">Username</label>
                      <input v-model="addForm.src" type="text" class="form-control" id="specificSizeInputGroupUserDebian" placeholder="Ссылка" required>
                    </div>

                    <div class="col-sm-2">
                      <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                      <select v-model="addForm.type" class="form-select" id="specificSizeSelect">
                        <option value="0" selected>Изображение</option>
                        <option value="1">WEB-форма</option>
                        <option value="2">Видео</option>
                      </select>
                    </div>

                    <div class="col-sm-1">
                      <label class="visually-hidden" for="specificSizeInputGroupUsername">Username</label>
                      <input v-model="addForm.time" type="number" class="form-control" id="specificSizeInputGroupUsername" placeholder="Время в сек" required>
                    </div>

                    <div class="col-auto">
                      <button @click="addEvent(this.editFormL, this.eventList.data.lunch)" type="submit" class="btn btn-success">Добавить</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button @click='templateSave()' type="button" class="btn btn-success" data-bs-dismiss="modal">Сохранить</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Details (SPECIAL) -->
    <div class="modal fade" id="detailsSpecialModal" tabindex="-1" data-bs-backdrop="static">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="exampleModalLabel1">Просмотр формы</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div v-if="this.eventList.data" class="modal-body">

            <div v-for="(event, index) in this.eventList.data.lesson" class="row gx-3 gy-2 align-items-center p-1">
              <div v-if="!editFormS[index].isDeleted" class="col-sm-3">
                <label class="visually-hidden" for="specificSizeInputName132">Name</label>
                <input v-model="event.name" type="text" class="form-control" id="specificSizeInputName132" placeholder="Имя"
                       :disabled="editFormS[index].isDisabled">
              </div>
              <div v-if="!editFormS[index].isDeleted" class="col-sm-2">
                <label class="visually-hidden" for="specificSizeInputGroupUsername135">Username</label>
                <input v-model="event.src" type="text" class="form-control" id="specificSizeInputGroupUsername135"
                       placeholder="Ссылка" :disabled="editFormS[index].isDisabled">
              </div>
              <div v-if="!editFormS[index].isDeleted" class="col-sm-2">
                <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                <select v-model="event.type" class="form-select" id="specificSizeSelect" :disabled="editFormS[index].isDisabled">
                  <option value="0">Изображение</option>
                  <option value="1">WEB-форма</option>
                  <option value="2">Видео</option>
                </select>
              </div>
              <div v-if="!editFormS[index].isDeleted" class="col-sm-1">
                <label class="visually-hidden" for="specificSizeInputGroupUsername88005553535">Username</label>
                <input v-model="event.time" type="number" class="form-control" id="specificSizeInputGroupUsername88005553535" placeholder="Время в сек" :disabled="this.editFormS[index].isDisabled">
              </div>

              <div v-if="!editFormS[index].isDeleted" class="col-auto">
                <button v-if="!editFormS[index].isDeleted && editFormS[index].isDisabled" @click="editEvent(index, this.editFormS)" class="btn btn-secondary">
                  Редактировать
                </button>
                <template v-if="!editFormS[index].isDisabled">
                  <button @click="saveEvent(index, this.editFormS)" class="btn btn-secondary"> Сохранить </button>
                  <button @click="delEvent(index, this.editFormS, this.eventList.data.lesson)" class="btn btn-outline-danger ms-1"> Удалить </button>
                </template>
              </div>
              <div v-if="!editFormS[index].isDeleted && editFormS[index].isDisabled" class="col-auto">
                <button @click="moveEvent('up', index, this.eventList.data.lesson)" class="btn btn-outline-warning"><i class="fa-solid fa-up"></i></button>
              </div>
              <div v-if="!editFormS[index].isDeleted && editFormS[index].isDisabled" class="col-auto">
                <button @click="moveEvent('down', index, this.eventList.data.lesson)" class="btn btn-outline-warning"><i class="fa-solid fa-down"></i></button>
              </div>
            </div>
            <!--ФОРМА ДОБАВЛЕНИЯ!!!!!!!!!-->
            <div class="row gx-3 gy-2 align-items-center p-1">
              <div class="col-sm-3">
                <label class="visually-hidden" for="specificSizeInputNameOfAkatsuki">Name</label>
                <input v-model="addForm.name" type="text" class="form-control" id="specificSizeInputNameOfAkatsuki" placeholder="Имя" required>
              </div>

              <!--            &lt;!&ndash;@change="onFileChange"&ndash;&gt;-->
              <!--          <div v-if="Number(addForm.type) === 0 || Number(addForm.type) === 2" class="col-sm-2">-->
              <!--            <input class="form-control" type="file" id="fileName" ref="file">-->
              <!--          </div>-->

              <!--          v-if="Number(addForm.type) === 1"-->
              <div class="col-sm-2">
                <label class="visually-hidden" for="specificSizeInputGroupUSA">Username</label>
                <input v-model="addForm.src" type="text" class="form-control" id="specificSizeInputGroupUSA" placeholder="Ссылка" required>
              </div>

              <div class="col-sm-2">
                <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                <select v-model="addForm.type" class="form-select" id="specificSizeSelect">
                  <option value="0" selected>Изображение</option>
                  <option value="1">WEB-форма</option>
                  <option value="2">Видео</option>
                </select>
              </div>

              <div class="col-sm-1">
                <label class="visually-hidden" for="specificSizeInputGroupUserAss">Username</label>
                <input v-model="addForm.time" type="number" class="form-control" id="specificSizeInputGroupUserAss" placeholder="Время в сек" required>
              </div>

              <div class="col-auto">
                <button @click="addEvent(this.editFormS, this.eventList.data.lesson)" type="submit" class="btn btn-success">Добавить</button>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button @click='templateSave()' type="button" class="btn btn-success" data-bs-dismiss="modal">Сохранить</button>
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
            Вы собираетесь отклонить "{{ this.forModal.name }}". Вы уверены?
            <div class="mb-3">
              <label for="message-text" class="col-form-label"><br> Комментарий бригаде:</label>
              <textarea v-model="this.forModal.comment" class="form-control" id="message-text"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button @click="buttonDeny(this.forModal)" type="button" class="btn btn-danger">Отклонить</button>
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
            Вы собираетесь утвердить данное расписание. <br> Вы уверены?
            <div class="mb-3">
              <label for="message-text" class="col-form-label"><br> Комментарий бригаде:</label>
              <textarea v-model="this.forModal.comment" class="form-control" id="message-text"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button @click="buttonAccess(this.forModal)" type="button" class="btn btn-success">Утвердить</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Delete -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="exampleModalLabela">Подтверждение</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            Вы собираетесь удалить шаблон "{{ this.forModal.name }}" из очереди. Вы уверены?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button @click="buttonDelete(this.forModal)" type="button" class="btn btn-danger">Удалить</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Save -->
    <div class="modal fade" id="saveModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="exampleModalLabela">Подтверждение</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            Вы собираетесь сохранить изменения в шаблоне "{{ this.forModal.name }}" из очереди. Вы уверены?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button @click="buttonSave(this.forModal)" type="button" class="btn btn-success">Уверен</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Set Active -->
    <div class="modal fade" id="activeModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="exampleModalLabela">Подтверждение</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            Вы собираетесь установить шаблон "{{ this.forModal.name }}" на трансляцию. <strong>Текущий активный шаблон будет удалён из системы</strong>. <br><br> Вы уверены?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button @click="setActive(this.forModal)" type="button" class="btn btn-success">Уверен</button>
          </div>
        </div>
      </div>
    </div>

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
                    <select class="form-select" aria-label="Default select example" :disabled="(!this.reqList[index].isStartedProcess || req.whoAccept !== this.username.name)">
                      <option selected>Кафедра К3 - основной</option>
                      <!-- <option value="1">Кафедра К3 - новости</option> -->
                    </select>
                    <input v-model="req.date" id="startDate1" class="form-control" type="date" :value="req.date" :disabled="(!this.reqList[index].isStartedProcess || req.whoAccept !== this.username.name)"/>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Пары:
                    <select v-model="req.lesson" class="form-select form-select-sm w-75" :disabled="(!this.reqList[index].isStartedProcess || req.whoAccept !== this.username.name)">
                      <option selected :value="req.lesson"> {{ req.lesson }} </option>
                      <option v-for="tmp in templatesToReplace" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Перерыв:
                    <select  v-model="req.breaktime" class="form-select form-select-sm w-75" :disabled="(!this.reqList[index].isStartedProcess || req.whoAccept !== this.username.name)">
                      <option selected :value="req.breaktime"> {{ req.breaktime }} </option>
                      <option v-for="tmp in templatesToReplace" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Обед:
                    <select  v-model="req.lunch" class="form-select form-select-sm w-75" :disabled="(!this.reqList[index].isStartedProcess || req.whoAccept !== this.username.name)">
                      <option selected :value="req.lunch"> {{ req.lunch }} </option>
                      <option v-for="tmp in templatesToReplace" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                    <div class="form-check form-switch">
                      <input :value="req.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault26" disabled/>
                      <label class="form-check-label" for="flexSwitchCheckDefault26"> Особое расписание </label>
                    </div>

                    <!--КНОПКИ ОБРАБОТКИ СОБЫТИЯ-->
                    <button v-if="!req.isStartedProcess" @click="startProcess(req, 'req')" class="btn btn-outline-secondary">
                        Обработать
                    </button>
                    <div v-if="req.isStartedProcess && (this.userProcess === req.name || req.whoAccept === this.username.name)" class="btn-group">
                      <button @click="endProcess(req, 'req')" type="button" class="btn btn-outline-secondary"> Отменить обработку </button>
                      <!-- Button trigger Details modal -->
                      <button @click="buttonOpen(req)"  type="button" class="btn btn-outline-info">Просмотр</button>
                      <!-- Button trigger Deny modal -->
                      <button @click="triggerModal('deny', req, index)" type="button" class="btn btn-outline-danger"> Отклонить</button>
                      <!-- Button trigger Confirm modal -->
                      <button @click="triggerModal('confirm', req, index)" type="button" class="btn btn-success"> Утвердить </button>
                    </div>
                    <div v-if="req.isStartedProcess && req.whoAccept !== this.username.name">
                      Событие находится в обработке у: <i> "{{ req.whoAccept }}" </i>
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
                    <select class="form-select" aria-label="Default select example" :disabled="(!this.reqList[index].isStartedProcess || req.whoAccept !== this.username.name)">
                      <option selected>Кафедра К3 - основной</option>
                      <!-- <option value="1">Кафедра К3 - новостной</option>
                      <option value="2">Хол актового</option> -->
                    </select>
                    <input v-model="req.date" id="startDate4" class="form-control" type="date" :value="req.date" :disabled="(!this.reqList[index].isStartedProcess || req.whoAccept !== this.username.name)"/>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Шаблон:
                    <select  v-model="req.lesson" class="form-select form-select-sm w-75" :disabled="(!this.reqList[index].isStartedProcess || req.whoAccept !== this.username.name)">
                      <option selected :value="req.lesson"> {{ req.lesson }} </option>
                      <option v-for="tmp in templatesToReplace" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                    <div class="form-check form-switch">
                      <input :value="req.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault37" checked disabled/>
                      <label class="form-check-label" for="flexSwitchCheckDefault37"> Особое расписание </label>
                    </div>

                    <!--КНОПКИ ОБРАБОТКИ СОБЫТИЯ-->
                    <button v-if="!req.isStartedProcess" @click="startProcess(req, 'req')" class="btn btn-outline-secondary">
                        Обработать
                    </button>
                    <div v-if="req.isStartedProcess && (this.userProcess === req.name || req.whoAccept === username)" class="btn-group">
                      <button @click="endProcess(req, 'req')" type="button" class="btn btn-outline-secondary"> Отменить обработку </button>
                      <!-- Button trigger Details modal -->
                      <button @click="buttonOpen(req)" type="button" class="btn btn-outline-info">Просмотр</button>
                      <!-- Button trigger Deny modal -->
                      <button @click="triggerModal('deny', req, index)" type="button" class="btn btn-outline-danger"> Отклонить</button>
                      <!-- Button trigger Confirm modal -->
                      <button @click="triggerModal('confirm', req, index)" type="button" class="btn btn-success"> Утвердить </button>
                    </div>
                    <div v-if="req.isStartedProcess && req.whoAccept !== this.username.name">
                      Событие находится в обработке у: <i> "{{ req.whoAccept }}" </i>
                    </div>
                  </div>
                  <!-- КОНЕЦ: Шаблон дня по особому расписанию -->
                </div>

              </li>
            </ul>
            <!-- КОНЕЦ: Входящие запросы на модерацю -->
          </div>

          <!-- АКТИВНОЕ ОТОБРАЖЕНИЕ (ЧТО ИГРАЕТ СЕГОДНЯ) -->
          <div class="tab-pane fade" id="pills-display" role="tabpanel" aria-labelledby="pills-display-tab" tabindex="0">

            <div v-for="(screen, index) in this.activeTmp" class="row row-cols-1 row-cols-lg-2 g-3">
                <!-- ПЛАШКА ДЛЯ 3х ШАБЛОНОВ -->
                <div v-if="!screen.isspecial" class="col-sm-6 mb-3">
                  <div class="card h-100">
                    <div class="card-header">
                      <h5 class="card-title m-0">Кафедра К3 - основной</h5>
                    </div>
                    <div class="card-body">
                      <div class="progress" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                        <div class="progress-bar progress-bar-striped bg-success progress-bar-animated" id="progress_workdays"> </div>
                      </div>
                      <div class="d-flex w-100 justify-content-between align-items-center">
                          <div id="time_workdays"></div>
                          <div id="nameInfo_workdays"></div>
                      </div>
                      <ul class="list-group display mt-1">
                      <!-- Шаблон для будних дней -->
                      <li class="list-group-item">
                          <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                              Пары:
                              <select class="form-select form-select-sm w-75" disabled>
                                  <option selected>{{ screen.lesson }}</option>
                                  <option value="1">По умолчанию (web-forms)</option>
                                  <option value="2">По умолчанию (новости)</option>
                              </select>
                          </div>
                          <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                              Перерыв:
                              <select class="form-select form-select-sm w-75" disabled>
                                  <option selected>{{ screen.breaktime }}</option>
                                  <option value="1">По умолчанию (web-forms)</option>
                                  <option value="2">По умолчанию (новости)</option>
                              </select>
                          </div>
                          <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                              Обед:
                              <select class="form-select form-select-sm w-75" disabled>
                                  <option selected>{{ screen.lunch }}</option>
                                  <option value="1">По умолчанию (web-forms)</option>
                                  <option value="2">По умолчанию (новости)</option>
                              </select>
                          </div>
                          <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                              <div class="form-check form-switch">
                                  <input :value="screen.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault1" disabled/>
                                  <label class="form-check-label" for="flexSwitchCheckDefault1"> Особое расписание </label>
                              </div>
                          </div>
                      <!-- КОНЕЦ: Шаблон для будних дней -->
                      </li>
                    </ul>
                    </div>
                    <div class="card-footer text-end">
                      <div class="d-flex w-100 justify-content-end align-items-center">
                        <!-- Button trigger Delete follow modal -->
                        <!-- <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteFollowModal"> Не отслеживать</button> -->
                        <button v-if="!screen.isStartedProcess" @click="startProcess(screen, 'act')" type="button" class="btn btn-outline-success">Редактировать</button>

                        <div v-if="screen.isStartedProcess && (this.userProcess === screen.name || screen.whoAccept === this.username.name)" class="btn-group">
                          <button @click="endProcess(screen, 'act')" type="button" class="btn btn-outline-secondary"> Отмена </button>
                          <!-- Button trigger Details modal -->
                          <button @click="buttonOpen(screen)"  type="button" class="btn btn-outline-info">Просмотр</button> 
                          <!-- Button trigger Confirm modal -->
                          <button @click="triggerModal('save', screen, index)" type="button" class="btn btn-success"> Сохранить </button>
                        </div>
                        <div v-if="screen.isStartedProcess && screen.whoAccept !== this.username.name">
                          Ведется обработка: <i> "{{ screen.whoAccept }}" </i>
                        </div>

                      </div>
                    </div>
                  </div>
                <!-- КОНЕЦ: ПЛАШКА ДЛЯ 3х ШАБЛОНОВ -->
                </div>
                <!-- ПЛАШКА ДЛЯ ОСОБОГО ДНЯ -->
                <div v-if="screen.isspecial" class="col-sm-6 mb-3">
                  <div class="card h-100">
                    <div class="card-header">
                      <h5 class="card-title m-0">Кафедра К3 - основной</h5>
                    </div>
                    <div class="card-body">
                      <div class="progress" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                        <div class="progress-bar progress-bar-striped bg-success progress-bar-animated" id="progress_special"> </div>
                      </div>
                      <div class="d-flex w-100 justify-content-between align-items-center">
                          <div id="time_special"></div>
                          <div id="nameInfo_special"></div>
                      </div>
                      <ul class="list-group display mt-1">
                      <!-- Шаблон для дня по особому расписанию -->
                      <li class="list-group-item">
                          <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                              Шаблон:
                              <select class="form-select form-select-sm w-75" disabled>
                                  <option selected>{{ screen.lesson }}</option>
                                  <option value="1">По умолчанию (web-forms)</option>
                                  <option value="2">По умолчанию (новости)</option>
                              </select>
                          </div>
                          <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                              <div class="form-check form-switch">
                                  <input :value="screen.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault2" disabled checked/>
                                  <label class="form-check-label" for="flexSwitchCheckDefault2"> Особое расписание </label>
                              </div>
                          </div>
                      <!-- КОНЕЦ: Шаблон для дня по особому расписанию -->
                      </li>
                    </ul>
                    </div>
                    <div class="card-footer text-end">
                      <div class="d-flex w-100 justify-content-end align-items-center">
                        <!-- Button trigger Delete follow modal -->
                        <!-- <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteFollowModal"> Не отслеживать</button> -->
                        <button v-if="!screen.isStartedProcess" @click="startProcess(screen, 'act')" type="button" class="btn btn-outline-success">Редактировать</button>

                        <div v-if="screen.isStartedProcess && (this.userProcess === screen.name || screen.whoAccept === this.username.name)" class="btn-group">
                          <button @click="endProcess(screen, 'act')" type="button" class="btn btn-outline-secondary"> Отмена </button>
                          <!-- Button trigger Details modal -->
                          <button @click="buttonOpen(screen)"  type="button" class="btn btn-outline-info">Просмотр</button> 
                          <!-- Button trigger Confirm modal -->
                          <button @click="triggerModal('confirm', screen, index)" type="button" class="btn btn-success"> Сохранить </button>
                        </div>
                        <div v-if="screen.isStartedProcess && screen.whoAccept !== this.username.name">
                          Ведется обработка: <i> "{{ screen.whoAccept }}" </i>
                        </div>
                        
                      </div>
                    </div>
                  </div>
                <!-- КОНЕЦ: ПЛАШКА ДЛЯ ОСОБОГО ДНЯ -->
                </div>
              <!-- КОНЕЦ ЦИКЛА ЭКРАНОВ -->
            </div>

            <!-- <div class="d-flex w-auto justify-content-start align-items-center gap-1 mt-2">
              <select class="form-select w-auto">
                <option selected>- Выберите -</option>
                <option value="1">Хол актового</option>
                <option value="2">Что-то ещё</option>
              </select>
              <div>
                <button type="button" class="btn btn-success">Добавить к ослеживанию</button>
              </div>
            </div> -->
            <!-- КОНЕЦ: Что СЕЙЧАС отображается на экранах -->
          </div>

          <!-- ОЧЕРЕДЬ ШАБЛОНОВ НА ОТОБРАЖЕНИЕ (УЖЕ УТВЕРЖДЕННЫЕ)  -->
          <div class="tab-pane fade" id="pills-queue" role="tabpanel" aria-labelledby="pills-queue-tab" tabindex="0">

            <ul class="list-group moder">
              <li v-for="(acc, index) in this.acceptedList" class="list-group-item">
                <!-- Шаблон для будних дней -->
                <div v-if="!acc.isspecial">
                  <div class="me-auto">
                    <div class="fw align-items-center">
                      <strong>{{ acc.name }}</strong> <small>(Send: <i>@{{ acc.author }}</i>,  accepted: <i>{{ acc.whoAccept }}</i>)</small>
                    </div>
                    <small class="fw align-items-center"> {{ acc.comment }} </small>
                  </div>
                  <div class="d-flex w-100 justify-content-between gap-1 mt-2">
                    <select class="form-select" aria-label="Default select example" :disabled="(!this.acceptedList[index].isStartedProcess || acc.whoAccept !== this.username.name)">
                      <option selected>Кафедра К3 - основной</option>
                      <!-- <option value="1">Кафедра К3 - новости</option> -->
                    </select>
                    <input v-model="acc.date" id="startDate3" class="form-control" type="date" :value="acc.date" :disabled="(!this.acceptedList[index].isStartedProcess || acc.whoAccept !== this.username.name)"/>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Пары:
                    <select class="form-select form-select-sm w-75" :disabled="(!this.acceptedList[index].isStartedProcess || acc.whoAccept !== this.username.name)">
                      <option selected :value="acc.lesson"> {{ acc.lesson }} </option>
                      <option v-for="tmp in templatesToReplace" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Перерыв:
                    <select class="form-select form-select-sm w-75" :disabled="(!this.acceptedList[index].isStartedProcess || acc.whoAccept !== this.username.name)">
                      <option selected :value="acc.breaktime"> {{ acc.breaktime }} </option>
                      <option v-for="tmp in templatesToReplace" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Обед:
                    <select class="form-select form-select-sm w-75" :disabled="(!this.acceptedList[index].isStartedProcess || acc.whoAccept !== this.username.name)">
                      <option selected :value="acc.lunch"> {{ acc.lunch }} </option>
                      <option v-for="tmp in templatesToReplace" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                    <div class="form-check form-switch">
                      <input :value="acc.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" disabled/>
                      <label class="form-check-label" for="flexSwitchCheckDefault"> Особое расписание </label>
                    </div>

                    <!--КНОПКИ ОБРАБОТКИ СОБЫТИЯ-->
                    <div v-if="!acc.isStartedProcess" class="btn-group">
                      <button @click="startProcess(acc, 'acc')" class="btn btn-outline-secondary">
                          Обработать
                      </button>
                      <!-- Button trigger SetActive modal -->
                      <button @click="triggerModal('active', acc, index)" type="button" class="btn btn-outline-warning">
                        Играть сейчас
                      </button>
                    </div>
                    <div v-if="acc.isStartedProcess && (this.userProcess === acc.name || acc?.whoAccept === this.username.name)" class="btn-group">
                      <button @click="endProcess(acc, 'acc')" type="button" class="btn btn-outline-secondary"> Отменить обработку </button>
                      <!-- Button trigger Details modal -->
                      <button @click="buttonOpen(acc)" type="button" class="btn btn-outline-info">Просмотр</button>
                      <!-- Button trigger Deny modal -->
                      <button @click="triggerModal('delete', acc, index)" type="button" class="btn btn-outline-danger"> Удалить </button>
                      <!-- Button trigger Confirm modal -->
                      <button @click="triggerModal('save', acc, index)" type="button" class="btn btn-success"> Применить </button>
                    </div>
                    <div v-if="acc.isStartedProcess && acc.whoAccept !== this.username.name">
                      Событие находится в обработке у: <i> "{{ acc.whoAccept }}" </i>
                    </div>
                  </div>
                <!-- КОНЕЦ: Шаблон для будних дней -->
                </div>

                <!-- Шаблон дня по особому расписанию -->
                <div v-if="acc.isspecial">
                  <div class="me-auto">
                    <div class="fw align-items-center">
                      <strong>{{ acc.name }}</strong> <small>(Send: <i>@{{ acc.author }}</i>,  accepted: <i>{{ acc.whoAccept }}</i>)</small>
                    </div>
                    <small class="fw align-items-center">{{ acc.comment }}</small>
                  </div>
                  <div class="d-flex w-100 justify-content-between gap-1 mt-2">
                    <select class="form-select" aria-label="Default select example" :disabled="(!this.acceptedList[index].isStartedProcess || acc.whoAccept !== this.username.name)">
                      <option selected>Кафедра К3 - основной</option>
                      <!-- <option value="1">Кафедра К3 - новостной</option>
                      <option value="2">Хол актового</option> -->
                    </select>
                    <input v-model="acc.date" id="startDate2" class="form-control" type="date"  :value="acc.date" :disabled="(!this.acceptedList[index].isStartedProcess || acc.whoAccept !== this.username.name)"/>
                  </div>
                  <div class=" d-flex w-100 justify-content-between align-items-center gap-1 mt-1">
                    Шаблон:
                    <select class="form-select form-select-sm w-75" :disabled="(!this.acceptedList[index].isStartedProcess || acc.whoAccept !== this.username.name)">
                      <option selected :value="acc.lesson"> {{ acc.lesson }} </option>
                      <option v-for="tmp in templatesToReplace" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                    </select>
                  </div>
                  <div class="d-flex w-100 justify-content-between align-items-center gap-1 mt-2">
                    <div class="form-check form-switch">
                      <input :value="acc.isspecial" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault3" checked disabled/>
                      <label class="form-check-label" for="flexSwitchCheckDefault3"> Особое расписание </label>
                    </div>

                    <!--КНОПКИ ОБРАБОТКИ СОБЫТИЯ-->
                    <div v-if="!acc.isStartedProcess" class="btn-group">
                      <button @click="startProcess(acc, 'acc')" class="btn btn-outline-secondary">
                          Обработать
                      </button>
                      <!-- Button trigger SetActive modal -->
                      <button @click="triggerModal('active', acc, index)" type="button" class="btn btn-outline-warning">
                        Играть сейчас
                      </button>
                    </div>
                    <div v-if="acc.isStartedProcess && (this.userProcess === acc.name || acc?.whoAccept === username)" class="btn-group">
                      <button @click="endProcess(acc, 'acc')" type="button" class="btn btn-outline-secondary"> Отменить обработку </button>
                      <!-- Button trigger Details modal -->
                      <button @click="buttonOpen(acc)" type="button" class="btn btn-outline-info">Просмотр</button>
                      <!-- Button trigger Deny modal -->
                      <button @click="triggerModal('delete', acc, index)" type="button" class="btn btn-outline-danger"> Удалить </button>
                      <!-- Button trigger Confirm modal -->
                      <button @click="triggerModal('save', acc, index)" type="button" class="btn btn-success"> Применить </button>
                    </div>
                    <div v-if="acc.isStartedProcess && acc.whoAccept !== this.username.name">
                      Событие находится в обработке у: <i> "{{ acc.whoAccept }}" </i>
                    </div>
                  </div>
                  <!-- КОНЕЦ: Шаблон дня по особому расписанию -->
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
import io from "socket.io-client";

export default {
  data() {
    return {
      connected: false,       // Socket.io connection 

      allFormList: [],        // Все упакованные данные для модератора (heap data)
      acceptedList: [],       // Утвержденные на данный момент расписания <Request form>
      reqList: [],            // Запросы редакторов на утверждение <Request form>
      activeTmp: [],          // Шаблон, играющий прямо сейчас <Template form>
      templatesToReplace: [], // Шаблоны на замену для корректировки и утверждения

      eventList: [],          // Список для событий открываемого шаблона
                              // Форма добавления нового события
      addForm: { name: "", src: "", type: 0, time: 15, isActive: true },
      editFormS: [],           // Форма редактирования события (Study)
      editFormB: [],           // Перерыв (Break)
      editFormL: [],           // Обед (Lunch)

      userProcess: '',        // Имя события, которое на данный момент обрабатывает модератор

      succCallback: [],       // Колбек - успешно
      errCallback: [],        // Колбек - ошибка

      successMessage: null,   // Текст успешной операции
      errorMessage: null,     // Текст ошибки

      forModal: {
        withChanges: false,
        upd_less: [],
        upd_break: [],
        upd_lunch: [],
        name: '',     // NOT NULL
        obj: {},      // NOT NULL
        index: '',
        comment: '',
      },

      // --- MODALKAS ---
      sendDetailWorkdays: '',
      sendDetailSpecial: '',
      denyModal: '',
      confirmModal: '',
      deleteModal: '',
      saveModal: '',
      actModal: '',

      currentTime: null,      // Текущее время (для отображения toggle)
      username: '',           // Информация о проф  иле (name: '', role: '')
      format: /[`!@#$%^&*()+=\[\]{};':"\\|,.<>\/?~]/
    }
  },
  methods: {
    connect() {
      this.connected = true;
      this.socket = io(`${process.env.API_URL}`);

      this.socket.on('process:start', (data) => {
        if (data.list === "req") {
            for (let i in this.reqList) {
              if (this.reqList[i].name === data.process) {
                this.reqList[i].isStartedProcess = true;
                this.reqList[i].inProcessing = true;
                this.reqList[i].whoAccept = data.user;
              }
            }
          } else if (data.list === "act") {
            for (let i in this.activeTmp) {
              if (this.activeTmp[i].name === data.process) {
                this.activeTmp[i].isStartedProcess = true;
                this.activeTmp[i].inProcessing = true;
                this.activeTmp[i].whoAccept = data.user;
              }
            }
          } else if (data.list === "acc") {
            for (let i in this.acceptedList) {
              if (this.acceptedList[i].name === data.process) {
                this.acceptedList[i].isStartedProcess = true;
                this.acceptedList[i].inProcessing = true;
                this.acceptedList[i].whoAccept = data.user;
              }
            }
          } else 
            console.log('error');
      });

      this.socket.on('process:end', (data) => {
        switch (data.list) {
          case 'req':
            for (let i in this.reqList) {
              if (this.reqList[i].name === data.process) {
                this.reqList[i].isStartedProcess = false;
                this.reqList[i].inProcessing = false;
              }
            }
            break;
          case 'act':
            for (let i in this.activeTmp) {
              if (this.activeTmp[i].name === data.process) {
                this.activeTmp[i].isStartedProcess = false;
                this.activeTmp[i].inProcessing = false;
              }
            }
            break;
          case 'acc':
            for (let i in this.acceptedList) {
              if (this.acceptedList[i].name === data.process) {
                this.acceptedList[i].isStartedProcess = false;
                this.acceptedList[i].inProcessing = false;
              }
            }
            break;
            // Завершение всех обработок данного пользователя во всех листах
          case 'all': 
            for (let i in this.reqList) {
              if (this.reqList[i].isStartedProcess && this.reqlist[i].whoAccept === data.name) {
                this.reqList[i].isStartedProcess = false;
                this.reqList[i].inProcessing = false;
              }
            }
            for (let i in this.activeTmp) {
              if (this.activeTmp[i].isStartedProcess && this.activeTmp[i].whoAccept === data.name) {
                this.activeTmp[i].isStartedProcess = false;
                this.activeTmp[i].inProcessing = false;
              }
            }
            for (let i in this.acceptedList) {
              if (this.acceptedList[i].isStartedProcess && this.acceptedList[i].whoAccept === data.name) {
                this.acceptedList[i].isStartedProcess = false;
                this.acceptedList[i].inProcessing = false;
              }
            }
            break;
          default:
            console.log('error');
        }
      });

      this.socket.on('process:confirm', async (data) => {
          // New data - уже с пометкой прерванной обработки
        let response = await fetch(` /moder/requests`, {
          method: 'GET',
            // THIS IS IMPORTANT
          headers: new Headers({
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Access-Control-Allow-Origin': '*'
          })
        });
        this.allFormList = (await response.json());    

          // Утверждение 
        if (data.list === 'req') {
          for (let i in this.allFormList) 
            if (this.allFormList[i].name === data.process) 
              this.acceptedList.push(this.allFormList[i]);

          for (let i in this.reqList) 
            if (this.reqList[i].name === data.process) 
              this.reqList.splice(i, 1);
          // ОБРАБОТКА ПРЕРВАНА С НОВЫМИ ДАННЫМИ
            
          // Сохранение
        } else if (data.list === 'acc') {
          let tmp; 

          for (let i in this.allFormList) 
            if (this.allFormList[i].name === data.process) 
              tmp = this.allFormList[i];

          for (let i in this.acceptedList) 
            if (this.acceptedList[i].name === data.process) 
              this.acceptedList[i] = tmp;
          // ОБРАБОТКА ПРЕРВАНА С НОВЫМИ ДАННЫМИ

        } else 
          console.log('error');
      });

      this.socket.on('process:deny', (data) => {
          // Отклонение 
        if (data.list === 'req') {
          for (let i in this.reqList) 
            if (this.reqList[i].name === data.process) 
              this.reqList.splice(i, 1);

          // Удаление из утвержденных
        } else if (data.list === 'acc') {
          for (let i in this.acceptedList) 
            if (this.acceptedList[i].name === data.process) 
              this.acceptedList.splice(i, 1);

        } else 
          console.log('error');
      });

      this.socket.on('request:new', async (data) => {
        let response = await fetch(` /moder/requests`, {
          method: 'GET',
          headers: new Headers({
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Access-Control-Allow-Origin': '*'
          })
        });
        this.allFormList = (await response.json());    

        for (let i in this.allFormList) 
          if (this.allFormList[i].name === data.request) 
            this.reqList.push(this.allFormList[i]);
      });
    },

    async ProgressBar(active) {
      let Lessons = [
        [30000, 31200, 'Перерыв'],                                    // Перерыв, с 8:20
        [31200, 36900, '1-ая пара'],                                  // 1ая пара, с 8:40
        [36900, 37500, 'Перерыв'],                                    // Перерыв, с 10:15
        [37500, 43200, '2-ая пара'],                                  // 2ая пара, с 10:25
        [43200, 46200, 'Обед'],                                       // Обед, С 12:00
        [46200, 51900, '3-ая пара'],                                  // 3ая пара, с 12:50
        [51900, 52500, 'Перерыв'],                                    // Перерыв, с 14:25
        [52500, 58200, '4-ая пара'],                                  // 4ая пара, с 14:35
        [58200, 58800, 'Перерыв'],                                    // Перерыв, с 16:10
        [58800, 64500, '5-ая пара'],                                  // 5ая пара, с 16:20
      ];
      let Special = [                                                 // Особое расписание
        [28800, 64800, 'Особое расписание'],                          // с 8:00 до 18:00
      ];

      async function getPercent(curSec, bSpecial) {
        let percent;
        if (!bSpecial) {                                              // Если БУДНИ
          for (let i in Lessons) {                                    // Бежим по заданным промежуткам
            if (curSec >= Lessons[i][0] && curSec < Lessons[i][1]) {  // Проверяем, в каком промежутке находимся
              let during = Lessons[i][1] - Lessons[i][0];             // Высчитываем продолжительность промежутка (1)
              let fromStart = Lessons[i][1] - curSec;                 // Сколько прошло с начала в промежутке (2)
              percent = 100 - (fromStart * 100) / during;             // Делим (2) на (1) и узнаём проценты
              return percent;                                         // Возвращаем посчитанный %
            }
          }
        } else {                                                      // Если СПЕЦИАЛЬНОЕ РАСПИСАНИЕ
          if (curSec >= Special[0][0] && curSec < Special[0][1]) {    // Проверяем, в каком промежутке находимся
            let during = Special[0][1] - Special[0][0];               // Высчитываем продолжительность промежутка (1)
            let fromStart = Special[0][1] - curSec;                   // Сколько прошло с начала в промежутке (2)
            percent = 100 - (fromStart * 100) / during;               // Делим (2) на (1) и узнаём проценты
            return percent;                                           // Возвращаем посчитанный %
          }
        }                                                             // После 17:55 и до 8:20 - Свободное время,
        return 100;                                                   // играет шаблон "Обед"
      }

      function getName(curSec, bSpecial) {                            // Узнать имя в зависимости от расписания
        if (!bSpecial) {                                              // Если БУДНИ
          for (let i in Lessons) {                                    // Проверяем, в каком промежутке находимся
            if (curSec >= Lessons[i][0] && curSec < Lessons[i][1]) {  // Если попадаем в один из заданных промежутков
              return Lessons[i][2];                                   // Возвращаем наименование промежутка
            }
          }
          return 'Свободное время';                                   // Иначе возвращаем "Свободное время"
        } else return 'Особое расписание';                            // Если СПЕЦИАЛЬНОЕ РАСПИСАНИЕ
      }                                                               // возвращаем "Особое расписание"

      function WhatTime() {                                           // Узнать время в секундах с начала дня
        let today = new Date();                                       // Получить текущее время и вернуть значение в секнудах
        return  (today.getHours() * 60 + today.getMinutes()) * 60 + today.getSeconds();
      }

      async function checkTime(i) {                                         // Преобразовать время к презентабельному виду
        if (i < 10) { i = '0' + i; }                                  // Если < 10 то добавить перед цифрой "0" для красоты
        return i;
      }

      async function startTime(active) {
        let today = new Date();
        let actualTime = await checkTime(today.getHours()) + ':' + await checkTime(today.getMinutes()) + ':' + await checkTime(today.getSeconds());

        for (let i in active) {
          if (!active[i].isspecial) {
            // Будни
            document.getElementById('time_workdays').innerHTML = actualTime;
            document.getElementById('progress_workdays').style['width'] = await getPercent(WhatTime(), false) + '%';
          } else {
            // Специальное расписание
            document.getElementById('time_special').innerHTML = actualTime;
            document.getElementById('progress_special').style['width'] = await getPercent(WhatTime(), true) + '%';
          }
        }
        setTimeout(async function () { await startTime(active); }, 1000);
      }
      await startTime(this.activeTmp);

      async function refreshAt(hours, minutes, seconds, active) {
        let now = new Date();
        let then = new Date();

        if ( now.getHours() > hours ||
            (now.getHours() === hours && now.getMinutes() > minutes) ||
            (now.getHours() === hours && now.getMinutes() === minutes && now.getSeconds() >= seconds)
        ) {
          then.setDate(now.getDate() + 1);
        }
        then.setHours(hours); then.setMinutes(minutes); then.setSeconds(seconds);
          // Установка тайм-аута до следующего вызова
        let timeout = then.getTime() - now.getTime();
        setTimeout(async function () {
            // Подстановка надписи в элемент при обновлении надписи
          for (let i in active) {
            if (!active[i].isspecial) {
              document.getElementById('nameInfo_workdays').innerHTML = await getName(WhatTime(),false);
            } else {
              document.getElementById('nameInfo_special').innerHTML = await getName(WhatTime(),true);
            }
          }
        }, timeout);
      }
        // Проверка времени для обновления надписи
      await refreshAt(8, 20, 3, this.activeTmp); await refreshAt(8, 40, 3, this.activeTmp); await refreshAt(10, 15, 3, this.activeTmp); await refreshAt(10, 25, 3, this.activeTmp);
      await refreshAt(12, 0, 3, this.activeTmp); await refreshAt(12, 50, 3, this.activeTmp); await refreshAt(14, 25, 3, this.activeTmp); await refreshAt(14, 35, 3, this.activeTmp);
      await refreshAt(16, 10, 3, this.activeTmp); await refreshAt(16, 20, 3, this.activeTmp); await refreshAt(17, 55, 3, this.activeTmp);

        // Подстановка надписи в элемент при загрузке страницы
      setTimeout(async function () {
        for (let i in active) {
          if (!active[i].isspecial) {
            document.getElementById('nameInfo_workdays').innerHTML = await getName(WhatTime(), false);
          } else {
            document.getElementById('nameInfo_special').innerHTML = await getName(WhatTime(), true);
          }
        }
      }, 1000);
    },
      // Получить время
    async getTime() {
      // Дата - время callback
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
      this.sendDetailWorkdays = new bootstrap.Modal(document.getElementById('detailsWorkdaysModal'));
      this.sendDetailSpecial = new bootstrap.Modal(document.getElementById('detailsSpecialModal'));
      this.denyModal = new bootstrap.Modal(document.getElementById('denyModal'));
      this.confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
      this.saveModal = new bootstrap.Modal(document.getElementById('saveModal'));
      this.deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
      this.actModal = new bootstrap.Modal(document.getElementById('activeModal'));

      this.succCallback = new bootstrap.Toast(document.getElementById("ToastSuccess"));
      this.errCallback = new bootstrap.Toast(document.getElementById("ToastError"));

        // Rendering page
      await fetch(` /moder/`, {});
      let response = await fetch(` /moder/requests`, {
        method: 'GET',
          // THIS IS IMPORTANT
        headers: new Headers({
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*'
        })
      });
        // Вся информация о запросах в системе
      this.allFormList = (await response.json());     // [ { ... , isAccess: true }, { ... , isAccess: false }, ... ]

      for (let i in this.allFormList) {
        if (this.allFormList[i].isActive) {
          this.activeTmp.push(this.allFormList[i]);
          continue;
        }
        if (this.allFormList[i].isAccepted === true) {
          this.acceptedList.push(this.allFormList[i]);
        } else {
          this.reqList.push(this.allFormList[i]);
        }
      }

      for (let i in this.reqList) {
        if (this.reqList[i].inProcessing) {
          this.reqList[i].isStartedProcess = true;
          if (this.reqList[i].whoAccept === this.username.name) {
            this.userProcess = this.reqList[i].name;
          }
        }
      }
    },
      // Переключение процесса обработки события <NAME> на противоположный (ALL)
    async switchProcess(name) {
      await fetch(` /moder/switchprocess`, this.options('PATCH', { name: name }));
      // this.reqList[name].whoAccept = (await response.json()).whoAccept;
    },
      // Начать процесс обработки
    async startProcess(obj, list) {
      await this.getTime();
      if (this.userProcess === '' && !obj.isStartedProcess) {
        
        const data = {
          list: list,
          process: obj.name,
          user: this.username.name
        }
          // Обновление данных об обработках у других модераторов
        this.socket.emit('new-process', data);

          // Собственные шаблоны и уже проверенные + те, что были отправлены в данном запросе
        let templates = await fetch(` /moder/alltmp`, this.options('PATCH', { name: obj.name })) ;
        this.templatesToReplace = (await templates.json());

        obj.isStartedProcess = true;
        obj.whoAccept = this.username.name;
        let name = obj.name;
        await this.switchProcess(name);
        this.userProcess = name;
      } else {
          // Процесс обработки уже начат
        this.errorMessage = 'Вы можете обрабатывать максимум одно событие! Сначала завершите текущую обработку.';
        this.errCallback.show();
      }
    },
      // Завершить процесс обработки
    async endProcess(obj, list) {
      const data = {
        list: list,
        process: obj.name,
        user: this.username.name
      }
        // Обновление данных об обработках у других модераторов
      this.socket.emit('end-process', data);

      obj.isStartedProcess = false;
      let name = obj.name;
      await this.switchProcess(name);
      this.userProcess = '';
      this.forModal.withChanges = false;
      this.forModal.upd_less = [];
      this.forModal.upd_break = [];
      this.forModal.upd_lunch = [];
    },
      // Заагрить модалку
    async triggerModal(type, obj, index) {
      this.forModal.name = obj.name;
      this.forModal.obj = obj;
      this.forModal.index = index;
      switch (type) {
        case 'confirm':
          this.forModal.comment = 'Утверждаю.';
          this.confirmModal.show();
          break;
        case 'deny':
          this.forModal.comment = 'Исправить ошибки.';
          this.denyModal.show();
          break;
        case 'delete':
          this.deleteModal.show();
          break;
        case 'save':
          this.saveModal.show();
          break;
        case 'active':
          this.actModal.show();
          break;
        default:
          // Угрозы
      }
    },
      //  Утверждение расписания
    async buttonAccess(struct) {
      await this.getTime();
      if (this.userProcess !== '') {
        if (struct.obj.isspecial) {
          struct.obj.breaktime = struct.obj.lesson;
          struct.obj.lunch = struct.obj.lesson;
        }
        let response;
        if (this.forModal.withChanges) {
          response = await fetch(` /moder/access`, this.options('PATCH', { has_changes: struct.withChanges, obj_req: struct.obj, comment: struct.comment, upd_less: struct.upd_less, upd_lunch: struct.upd_lunch, upd_break: struct.upd_break }));
        } else {
          response = await fetch(` /moder/access`, this.options('PATCH', { obj_req: struct.obj, comment: struct.comment }));
        }
        let message = (await response.json());
        if (message.message !== 'errdate') {
          this.reqList[struct.index].isStartedProcess = false;
          this.reqList[struct.index].isAccepted = true;
          this.acceptedList.push(this.reqList[struct.index]);
          this.reqList.splice(struct.index, 1);
          this.successMessage = 'Запрос "' + struct.name + '" был успешно утвержден.';
          this.succCallback.show();
          this.confirmModal.hide();
          this.userProcess = '';
          this.forModal.withChanges = false;
          this.forModal.upd_less = [];
          this.forModal.upd_break = [];
          this.forModal.upd_lunch = [];

          const data = {
            list: 'req',
            process: struct.name,
            user: this.username.name
          }
          this.socket.emit('con-process', data);

        } else {
          this.errorMessage = 'Уже существует утвержденное событие на этот день.';
          this.errCallback.show();
        }
      } else {
        this.errorMessage = 'Некорректный параметр. Начните обработку корректно.';
        this.errCallback.show();
      }
    },
      // Отклонение расписания
    async buttonDeny(struct) {
      await this.getTime();
      if (this.userProcess !== '') {
        // let response =
            await fetch(` /moder/deny`, this.options('PUT', { name: struct.name, comment: struct.comment }));
        this.reqList.splice(struct.index, 1);

        const data = {
          list: 'req',
          process: struct.name,
          user: this.username.name
        }
        this.socket.emit('del-process', data);

        this.successMessage = 'Запрос "' + struct.name + '" был успешно отклонен.';
        this.succCallback.show();
        this.denyModal.hide();
        this.userProcess = '';
        this.forModal.withChanges = false;
        this.forModal.upd_less = [];
        this.forModal.upd_break = [];
        this.forModal.upd_lunch = [];
      } else {
        this.errorMessage = 'Некорректный параметр. Начните обработку корректно.';
        this.errCallback.show();
      }
    },
      // Удаление шаблона трансляции из очереди
    async buttonDelete(struct) {
      await this.getTime();
      if (this.userProcess !== '') {
        // let response =
        await fetch(` /moder/deny`, this.options('PUT', { name: struct.name, comment: struct.comment }));
        this.acceptedList.splice(struct.index, 1);

        const data = {
          list: 'acc',
          process: struct.name,
          user: this.username.name
        }
        this.socket.emit('del-process', data);

        this.successMessage = 'Запрос "' + struct.name + '" был успешно удален.';
        this.succCallback.show();
        this.deleteModal.hide();
        this.userProcess = '';
        this.forModal.withChanges = false;
        this.forModal.upd_less = [];
          this.forModal.upd_break = [];
          this.forModal.upd_lunch = [];
      } else {
        this.errorMessage = 'Некорректный параметр. Начните обработку корректно.';
        this.errCallback.show();
      }
    },
      // Сохранение изменений в шаблоне на очереди
    async buttonSave(struct) {
      await this.getTime();
      if (this.userProcess !== '') {
        if (struct.obj.isspecial) {
          struct.obj.breaktime = struct.obj.lesson;
          struct.obj.lunch = struct.obj.lesson;
        }
        let response;
        if (struct.withChanges) {
          response = await fetch(` /moder/access`, this.options('PATCH', { has_changes: struct.withChanges, obj_req: struct.obj, comment: struct.comment, upd_less: struct.upd_less, upd_lunch: struct.upd_lunch, upd_break: struct.upd_break }));
        } else {
          response = await fetch(` /moder/access`, this.options('PATCH', { obj_req: struct.obj, comment: struct.comment }));
        }
        let message = (await response.json());
        console.log(message);

        const data = {
          list: 'acc',
          process: struct.name,
          user: this.username.name
        }
        this.socket.emit('con-process', data);

        this.acceptedList[struct.index].isStartedProcess = false;
        this.successMessage = 'В запрос "' + struct.name + '" успешно внесены изменения.';
        this.succCallback.show();
        this.saveModal.hide();
        this.userProcess = '';
        this.forModal.withChanges = false;
        this.forModal.upd_less = [];
        this.forModal.upd_break = [];
        this.forModal.upd_lunch = [];
      } else {
        this.errorMessage = 'Некорректный параметр. Начните обработку корректно.';
        this.errCallback.show();
      }
    },
      // Details
    async buttonOpen(obj) {
      if (!this.forModal.withChanges) {
        let response = await fetch(` /moder/details`, this.options('PATCH', { obj: obj }));
        this.eventList = (await response.json());

        this.editFormS = [];
        this.editFormB = [];
        this.editFormL = [];

        if (this.eventList.data.lesson !== '-')
          for (let i in this.eventList.data.lesson) {
            if (!this.editFormS[i]) this.editFormS[i] = {}
            this.editFormS[i].isDisabled = true;
          }

        if (this.eventList.data.breaktime !== 'lesson')
          for (let i in this.eventList.data.breaktime) {
            if (!this.editFormB[i]) this.editFormB[i] = {}
            this.editFormB[i].isDisabled = true;
          }

        if (this.eventList.data.lunch !== 'lesson' && this.eventList.data.lunch !== 'breaktime')
          for (let i in this.eventList.data.lunch) {
            if (!this.editFormL[i]) this.editFormL[i] = {}
            this.editFormL[i].isDisabled = true;
          }
      }

      if (this.eventList.type === true) {
        this.sendDetailSpecial.show();
      } else if (this.eventList.type === false) {
        this.sendDetailWorkdays.show();
      } else {
        console.log('Форма сломана. Я уже сообщил администратору.');
      }
    },
      // Save template corrections
    async templateSave() {
        // 1. Форма не должна быть "испорчена" - возможно нарочное удаление структуры [.data]
        // 2. При внесении изменений в шаблон любого типа хотя бы в одной из форм должны быть события
        //    (невозможно сохранить, удалив все события из всех шаблонов, поскольку такой запрос нет смысла утверждать)
      if (this.eventList.data) {
        this.forModal.withChanges = true;
        this.forModal.upd_less = this.eventList.data.lesson;
        this.forModal.upd_break = this.eventList.data.breaktime;
        this.forModal.upd_lunch = this.eventList.data.lunch;
      }
    },
      // Set Active Now button
    async setActive(req) {
      if (req.obj.isAccepted) {
        await fetch(` /moder/setactive`, this.options('PUT', { name: req.name }));

        this.activeTmp = [];
        this.activeTmp.push(this.acceptedList[req.index]);
        this.acceptedList.splice(req.index, 1);

        this.successMessage = 'Запрос "' + req.name + '" был успешно установлен на воспроизведение.';
        this.succCallback.show();
        this.actModal.hide();

        this.ProgressBar(this.activeTmp);

      } else {
        console.log('error');
      }
    },

      // Работа со списками событий внутри шаблонов
    async addEvent(form, data) {
      await this.getTime();

      if (this.addForm.name !== "" && (this.addForm.src !== "")) {
        if (this.addForm.name.length > 50) {
          // Слишком длинное имя
          this.errorMessage = 'Полученно слишком длинное наименование события. \nПроверьте, пожалуйста, правильность введённых данных. \nРазрешено символов: 50. Получено: ' + this.addForm.name.length;
          this.errCallback.show();
        } else if (!Number.isFinite(this.addForm.time) || this.addForm.time < 0) {
          this.errorMessage = 'Полчено некорректное значение времени при добавлении события. \n Проверьте, пожалуйста, правильность введённых данных.';
          this.errCallback.show();
        } else if (this.format.test(this.addForm.name)) {
          this.errorMessage = 'Имя события не должно содержать специальных символов: \n' + this.format;
          this.errCallback.show();
        } else {
          // ----- CORRECT PROCESSING ----

          // if (Number(this.addForm.type) === 1) {
          //     // Обработка файла загрузки
          //
          // }
          // Обработка URL-адреса
          form.push({isDisabled: true});
          data.push(this.addForm);
          this.addForm = {name: "", src: "", type: 0, time: 15, isActive: true}

        }
      } else {
        // Нулевые поля для события
        this.errorMessage = 'Пожалуйста, заполните все поля перед добавлением.';
        this.errCallback.show();
      }
    },
    async delEvent(index, form, data) {
      form[index].isDisabled = true;
      form.splice(index, 1);
      data.splice(index, 1);
    },
    async editEvent(index, form) {
      form[index].isDisabled = false;
    },
    async saveEvent(index, form) {
      form[index].isDisabled = true;
    },
    async moveEvent(move, index, data) {
      let id1 = index;
      let id2 = null;
      if (move === "down" && id1 !== data.length-1)  id2 = id1++;
      if (move === "up" && id1 !== 0)  id2 = id1--;
      if (id2 !== null) this.correctArr(data, [id1, id2]);

    },
    correctArr(_arr, _param){
      /*
          коррекция  элементов массива по паре индекса
          *    _arr -- массив требующий коррекции
          *   _param -- пара [n1,n2] -- индексы массива для взаимной  перестановки
      */
      _arr[_param[1]] = _arr.splice(_param[0],1, _arr[_param[1]])[0]
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
    this.connect();
    this.getRequests(); // Получение списка всех запросов для последующей отрисовки
    this.username = window.user;
    this.ProgressBar(this.activeTmp); // Запускаем бесконечную залупу

    window.addEventListener('beforeunload', async function (event) {
       // Обновление данных об обработках у других модераторов
      // this.socket.emit('end-process', {
      //   list: 'all',
      //   process: '-',
      //   user: this.username.name
      // });

      await fetch(`/moder/endprocess`, {
        method: 'PUT',
          headers: {
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({ name: window.user.name }),
      });

      event.preventDefault();
      event.returnValue = '';
    });
  }
}

</script>