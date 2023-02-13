<template>
    <link href="/css/editor_style.css" rel="stylesheet" />
    <link href="/css/fa.min.css" rel="stylesheet" />
    <div class="intro">
        <div class="container"  data-bs-theme="dark">
            <h6 class="text p-0 mt-4"> Работа с трансляцией </h6>

            <!-- Error Modal -->
            <div class="modal fade" id="modalError" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
              <div class="modal-dialog">
                <!-- Переполнение в имени события при добавлении (огрн: 50 сим) -->
                <div v-if="errorFlag === 0" class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5">Ошибка добавления</h1>
                    <button @click="triggerStupid()" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    Полученно слишком длинное наименование события. <br> Проверьте, пожалуйста, правильность введённых данных <br> Разрешено символов: 50. Получено: {{ this.addForm.name.length }}
                  </div>
                  <div class="modal-footer">
                    <button @click="triggerStupid()" type="button" class="btn btn-danger" data-bs-dismiss="modal">Понятненько</button>
                  </div>
                </div>
                <!-- Отридцательное время или НЕ ЦИФРЫ в поле для времени -->
                <div v-if="errorFlag === 1" class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5">Ошибка добавления</h1>
                    <button @click="triggerStupid()" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    Полчено некорректное значение времени при добавлении события. <br> Проверьте, пожалуйста, правильность введённых данных
                  </div>
                  <div class="modal-footer">
                    <button @click="triggerStupid()" type="button" class="btn btn-danger" data-bs-dismiss="modal">Виноват, исправлюсь</button>
                  </div>
                </div>
                <!-- Отсутствует имя шаблона в момент создания -->
                <div v-if="errorFlag === 2" class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5">Ошибка создания шаблона</h1>
                    <button @click="triggerStupid()" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    Пожалуйста, укажите название шаблона, который хотите создать
                  </div>
                  <div class="modal-footer">
                    <button @click="triggerStupid()" type="button" class="btn btn-danger" data-bs-dismiss="modal">Ой, точно</button>
                  </div>
                </div>
                <!-- Не выбран шаблон для открытия -->
                <div v-if="errorFlag === 3" class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5">Ошибка открытия шаблона</h1>
                    <button @click="triggerStupid()" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    Пожалуйста, выберите шаблон, который хотите открыть
                  </div>
                  <div class="modal-footer">
                    <button @click="triggerStupid()" type="button" class="btn btn-danger" data-bs-dismiss="modal">А, ой</button>
                  </div>
                </div>
                <!-- Попытка открыть удаленный шаблон -->
                <div v-if="errorFlag === 4" class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5">Ошибка открытия шаблона</h1>
                    <button @click="triggerStupid()" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    Данный шаблон был удален его автором. <br> Свяжитесь с автором шаблона для уточнения информации
                  </div>
                  <div class="modal-footer">
                    <button @click="triggerStupid()" type="button" class="btn btn-danger" data-bs-dismiss="modal" onclick="location.reload(); return;">Окееей</button>
                  </div>
                </div>
                <!-- Нулевые поля для нового события -->
                <div v-if="errorFlag === 5" class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5">Ошибка добавления</h1>
                    <button @click="triggerStupid()" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    Пожалуйста, заполните все поля перед добавлением
                  </div>
                  <div class="modal-footer">
                    <button @click="triggerStupid()" type="button" class="btn btn-danger" data-bs-dismiss="modal" onclick="location.reload(); return;">Так точно!</button>
                  </div>
                </div>
                <!-- Не выбран шаблон, который нужно удалить -->
                <div v-if="errorFlag === 6" class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5">Ошибка удаления шаблона</h1>
                    <button @click="triggerStupid()" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    Выберите шаблон, который хотите удалить.
                  </div>
                  <div class="modal-footer">
                    <button @click="triggerStupid()" type="button" class="btn btn-danger" data-bs-dismiss="modal" onclick="location.reload(); return;">Будет исполнено!</button>
                  </div>
                </div>
                <!-- Имя шаблона не должно превышать 30 символов -->
                <div v-if="errorFlag === 7" class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5">Ошибка создания шаблона</h1>
                    <button @click="triggerStupid()" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    Полученно слишком длинное наименование шаблона. <br> Проверьте, пожалуйста, правильность введённых данных <br> Разрешено символов: 30. Получено: {{ this.name.length }}
                  </div>
                  <div class="modal-footer">
                    <button @click="triggerStupid()" type="button" class="btn btn-danger" data-bs-dismiss="modal" onclick="location.reload(); return;">Хорошо, сократим</button>
                  </div>
                </div>
              </div>
            </div>

            <div class="content">
                <div style="margin-right: 0">
                  <div class="d-flex justify-content-between">
                      <div class="input-group">
                        <!-- v-for="tmp in this.tmpList" -->
                          <select v-model="tmpName" class="form-select" id="inputGroupSelect04">
                              <option value="-" selected>- Выберите -</option>
                              <option v-for="tmp in tmpList" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                          </select>
                          <button @click="getTmp(tmpName)" class="btn btn-outline-secondary" type="button">Открыть</button>
                      </div>

                      <div class="d-flex justify-content-end ms-2">
                          <div v-if="canEdit || isAuthor" class="btn-group w-auto" role="group">
                              <!-- Button trigger Save modal -->
                              <button type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#ModalSave" >Сохранить</button>
                              <!-- Button trigger Delete modal -->
                              <button v-if="isAuthor" type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#ModalDelete" >Удалить</button>
                          </div>
                          <!-- Button trigger Send modal -->
                          <button type="button" class="btn btn-success ms-2 w-auto" data-bs-toggle="modal"  data-bs-target="#SendModerModal" > Отправить </button>
                      </div>
                  </div>
                  
                  <div class="input-group mt-2">
                      <input v-model="name" id="name" name="name" type="text" class="form-control" placeholder="Имя нового шаблона">
                      <button @click="addTmp(name, 'empty', [])" class="btn btn-outline-secondary" type="button">Создать пустой</button>
                      <button @click="addTmp(name, 'default', [])" class="btn btn-outline-secondary" type="button">Создать по умолчанию</button>
                      <button @click="addTmp(name, 'copy', this.events)" class="btn btn-outline-secondary" type="button">Создать копию</button>
                  </div>

                  <!-- Modal for Save -->
                  <div class="modal fade" id="ModalSave" tabindex="-1" aria-hidden="true"  >
                      <div class="modal-dialog">
                          <div class="modal-content">
                              <div class="modal-header">
                                  <h1 class="modal-title fs-5">Подтверждение сохранения</h1>
                                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                              </div>
                              <div class="modal-body">
                                  Вы собираетесь сохранить изменения в шаблоне "{{ tmpName }}". <br> Вы уверены?
                              </div>
                              <div class="modal-footer">
                                  <button type=" " class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                                  <button type=" " class="btn btn-success" href="#" @click="saveChanges" onclick="location.reload(); return;">Сохранить</button>
                              </div>
                          </div>
                      </div>
                  </div>

                  <!-- Modal for Delete -->
                  <div class="modal fade" id="ModalDelete" tabindex="-1" aria-hidden="true"  >
                      <div class="modal-dialog">
                          <div class="modal-content">
                              <div class="modal-header">
                                  <h1 class="modal-title fs-5">Подтверждение удаления</h1>
                                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                              </div>
                              <div class="modal-body">
                                  Вы собираетесь удалить шаблон "{{ tmpName }}". <br> Вы уверены?
                              </div>
                              <div class="modal-footer">
                                  <button type="" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                                  <button type="" @click="delTmp(tmpName)" onclick="location.reload(); return;" class="btn btn-danger">Удалить</button>
                              </div>
                          </div>
                      </div>
                  </div>
                
                <!-- SWITCHS -->
                <div v-if="isGet" class="d-flex w-100 justify-content-start align-items-center gap-3 mt-1">
                    <!-- SWITCH - Видимость -->
                    <div v-if="isAuthor" class="form-check form-switch mt-1">
                        <input class="form-check-input" type="checkbox" role="switch" v-model="canView" v-bind:checked="canView">
                        <label class="form-check-label" for="flexSwitchCheckDefault">Разрешить просматривать другим</label>
                    </div>
                    <!-- SWITCH - Реактирование -->
                    <div v-if="canView && isAuthor" class="form-check form-switch mt-1">
                        <input class="form-check-input" type="checkbox" role="switch" v-model="canEdit" v-bind:checked="canEdit">
                        <label class="form-check-label" for="flexSwitchCheckDefault">Разрешить редактировать другим</label>
                    </div>
                </div>
            </div>
            
            <!-- Modal for Send -->
            <div class="modal fade" id="SendModerModal" tabindex="-1" aria-hidden="true"  >
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel"> Отправить форму на модерацию </h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label for="recipient-name" class="col-form-label">Название:</label>
                                <input v-model="nameProg" type="text" class="form-control" id="recipient-name" />
                            </div>
                            <div class="mb-3">
                                <label for="message-text" class="col-form-label">Комментарий:</label>
                                <textarea v-model="commProg" class="form-control" id="message-text"></textarea>
                            </div>
                        </form>
                        </div>
                        <div class="modal-footer">
                            <div v-if="!specProg"> 
                              <div class="d-flex w-100 justify-content-between align-items-center gap-1">
                                  Пары: 
                                  <select v-model="studProg" class="form-select form-select-sm w-75" aria-label=".form-select-sm example">
                                      <option value="-" selected>- Нет изменений -</option>
                                      <option v-for="tmp in tmpList" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                                  </select>
                              </div>
                              <div class="d-flex w-100 justify-content-between align-items-center gap-1">
                                  Перерыв: 
                                  <select v-model="breakProg" class="form-select form-select-sm w-75" aria-label=".form-select-sm example">
                                      <option value="-" selected>- Нет изменений -</option>
                                      <option v-for="tmp in tmpList" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                                  </select>
                              </div>
                              <div class="d-flex w-100 justify-content-between align-items-center gap-1">
                                  Обед: 
                                  <select v-model="lunchProg" class="form-select form-select-sm w-75" aria-label=".form-select-sm example">
                                      <option value="-" selected>- Нет изменений -</option>
                                      <option v-for="tmp in tmpList" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                                  </select>
                              </div>
                            </div>

                            <div v-if="specProg"> 
                              <div class="d-flex w-100 justify-content-between align-items-center gap-1">
                                  Особый: 
                                  <select v-model="studProg" class="form-select form-select-sm w-75" aria-label=".form-select-sm example">
                                      <option value="-" selected>- Нет изменений -</option>
                                      <option v-for="tmp in tmpList" v-bind:value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                                  </select>
                              </div>
                            </div>

                            <div class="d-flex w-100 justify-content-between gap-1">
                                <select v-model="screenProg" class="form-select" aria-label="Default select example">
                                    <option selected value="1">Кафедра К3 - основной</option>
                                </select>
                                <input v-model="dateProg" id="startDate" class="form-control" type="date" />
                            </div>
                            <div class="d-flex w-100 justify-content-between align-items-center">
                                <div class="form-check form-switch">
                                    <input v-model="specProg" class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault">
                                    <label class="form-check-label" for="flexSwitchCheckDefault">Особое расписание</label>
                                </div>
                                <div>       
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"> Отмена </button>
                                    <button @click="sendTemplate()" type="button" class="btn btn-success ms-2"> Отправить </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
          </div>
          <div v-if="isGet" class="content">
              <div class="row gx-3 gy-2 align-items-center">
                <div class="col-sm-3">
                  <p class="text_mini">Наименование события</p>
                </div>

                <div class="col-sm-2">
                  <p class="text_mini">Ссылка на ресурс</p>
                </div>

                <div class="col-sm-2">
                  <p class="text_mini">Тип ресурса</p>
                </div>

                <div class="col-sm-1">
                  <p class="text_mini">Время (с.)</p>
                </div>
              </div>

              <div v-for="(event, index) in events" class="row gx-3 gy-2 align-items-center p-1">
                <div v-if="!editForm[index].isDeleted" class="col-sm-3">
                  <label class="visually-hidden" for="specificSizeInputName1">Name</label>
                  <input v-model="event.name" type="text" class="form-control" id="specificSizeInputName1" placeholder="Имя"
                          :disabled="editForm[index].isDisabled">
                </div>
                <div v-if="!editForm[index].isDeleted" class="col-sm-2">
                  <label class="visually-hidden" for="specificSizeInputGroupUsername1">Username</label>
                  <input v-model="event.src" type="text" class="form-control" id="specificSizeInputGroupUsername1"
                          placeholder="Ссылка" :disabled="editForm[index].isDisabled">
                </div>
                <div v-if="!editForm[index].isDeleted" class="col-sm-2">
                  <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                  <select v-model="event.type" class="form-select" id="specificSizeSelect" :disabled="editForm[index].isDisabled">
                    <option value="0">Изображение</option>
                    <option value="1">WEB-форма</option>
                    <option value="2">Видео</option>
                  </select>
                </div>
                <div v-if="!editForm[index].isDeleted" class="col-sm-1">
                  <label class="visually-hidden" for="specificSizeInputGroupUsername2">Username</label>
                  <input v-model="event.time" type="number" class="form-control" id="specificSizeInputGroupUsername2" placeholder="Время в сек" :disabled="editForm[index].isDisabled">
                </div>

                <div v-if="!editForm[index].isDeleted && (canEdit || isAuthor)" class="col-auto">
                  <button v-if="!editForm[index].isDeleted && editForm[index].isDisabled" @click="editEvent(index)" class="btn btn-secondary">
                    Редактировать
                  </button>
                  <template v-if="!editForm[index].isDisabled">
                    <button @click="saveEvent(index)" class="btn btn-secondary"> Сохранить </button>
                    <button @click="delEvent(index)" class="btn btn-outline-danger ms-1"> Удалить </button>
                  </template>
                </div>
                <div v-if="!editForm[index].isDeleted && editForm[index].isDisabled && (canEdit || isAuthor)" class="col-auto">
                  <button @click="moveEvent('up', index)" class="btn btn-outline-warning"><i class="fa-solid fa-up"></i></button>
                </div>
                <div v-if="!editForm[index].isDeleted && editForm[index].isDisabled && (canEdit || isAuthor)" class="col-auto">
                  <button @click="moveEvent('down', index)" class="btn btn-outline-warning"><i class="fa-solid fa-down"></i></button>
                </div>
              </div>

              <div v-if="canEdit || isAuthor" class="row gx-3 gy-2 align-items-center p-1">
                <div class="col-sm-3">
                  <label class="visually-hidden" for="specificSizeInputName">Name</label>
                  <input v-model="addForm.name" type="text" class="form-control" id="specificSizeInputName" placeholder="Имя" required>
                </div>

                <div class="col-sm-2">
                  <label class="visually-hidden" for="specificSizeInputGroupUsername3">Username</label>
                  <input v-model="addForm.src" type="text" class="form-control" id="specificSizeInputGroupUsername3" placeholder="Ссылка" required>
                </div>

                <div class="col-sm-2">
                  <label class="visually-hidden" for="specificSizeSelect">Preference</label>
                  <select v-model="addForm.type" class="form-select" id="specificSizeSelect">
                    <option value="0">Изображение</option>
                    <option value="1">WEB-форма</option>
                    <option value="2">Видео</option>
                  </select>
                </div>

                <div class="col-sm-1">
                  <label class="visually-hidden" for="specificSizeInputGroupUsername">Username</label>
                  <input v-model="addForm.time" type="number" class="form-control" id="specificSizeInputGroupUsername" placeholder="Время в сек" required>
                </div>

                <div class="col-auto">
                  <button @click="addEvent" type="submit" class="btn btn-success">Добавить</button>
                </div>

              </div>
              <br>
            </div>
        </div>
    </div>
</template>


<script>
export default {
  data() {
    return {
        // --- ПОЛЯ ДЛЯ ОТПРАВКИ ЗАПРОСОВ ---
      openedTmp: "",        // Имя открытого шаблона
      lastModify: "",       // Последний профиль, вносивший изменения в шаблон
      name: "",             // Поле "Имя нового шаблона"
      tmpName: "-",         // Селектор имен шаблонов для открытия 
        // --- ПАРАМЕТРЫ ДОСТУПА ---
      isAuthor: false,      // Является ли пользователь автором шаблона
      canView: false,       // Видимость шаблона для др. профилей
      canEdit: false,       // Возможность редактировать шаблон другими пользователями
      isGet: false,         // Состояние страницы - открыт ли шаблон
      errorFlag: -1,        //

        // --- SEND TO MODER ---
      nameProg: '',       // Заголовок шаблона
      commProg: '',       // Комментарий редактора
      studProg: '-',      // Программа на пары
      breakProg: '-',     // Программа на перерыв
      lunchProg: '-',     // Программа на обед
      screenProg: '1',    // Моник
      dateProg: '',       // Дата чето там
      specProg: false,    // Ты СПЕЦИАЛЬНО?

        // --- ЧИТАЕМЫЕ ДАННЫЕ ИЗ ОТВЕТОВ СЕРВЕРА ---
      tmpList: {},          // Список шаблонов для развертывания
      events: {},           // События (список, упорядоченный согласно базе данных)
      editForm: [],         // Форма редактирования события  
                            // Форма добавления нового события с полями 
      addForm: { name: "", src: "", type: 0, time: 15, isActive: true },
      // ${process.env.API_URL}
    }
  },
  methods: {
    getBoot() {
      return new bootstrap.Modal(document.getElementById('modalError'));
    },
    async allTmp() { 
      let response = await fetch(`/event/alltmp`, {
        method: 'GET',
          // THIS IS IMPORTANT
        headers: new Headers({
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*'
        })
      });
      this.tmpList = (await response.json());
    },
    async getTmp(name) {
      if (name !== "-") {
        let response = await fetch(`/event/all`, this.options('PATCH', { name: name }));
        this.events = (await response.json());
      
        if (this.events[0].name === "none" && this.events[0].src === "none"){
          this.events = [];
          this.errorFlag = 4;
          this.getBoot().show();
        } else {
          this.canView = this.events[0].canview;
          this.canEdit = !this.events[0].isprivate;
          this.isAuthor = this.events[0].isauthor;

          if (this.events[0].name === "undef" && this.events[0].src === "undef") {
            this.events = [];
          }
          this.openedTmp = name;
          this.isGet = true;
            
          for (var i in this.events) {
            if (!this.editForm[i]) this.editForm[i] = {}
            this.editForm[i].isDisabled = true;
          }
        }
      } else {
        this.errorFlag = 3;
        this.getBoot().show();
      }
    },
    async addTmp(name, tmp_type, events) {
      if (this.name.length > 30) {
        this.errorFlag = 7;
        this.getBoot().show();
      } else if (name !== "") {
        await fetch(`/event/addtmp`, this.options('PUT', { name: name, tmp_type: tmp_type, events: events }));
        let responseAdd = await fetch(`/event/alltmp`, {});
        this.tmpList = (await responseAdd.json());
        this.tmpName = name;
        this.name = "";
        await this.getTmp(name);
      } else {
        this.errorFlag = 2;
        this.getBoot().show();
      }
    },
    async delTmp(name) {
      if (name !== "-") {
        await fetch(`/event/deltmp`, this.options('DELETE', { name: name }));
        this.openedTmp = "";
        this.isGet = false;
        this.tmpName = "";
        this.canEdit = false;
        this.canView = false;
        this.isAuthor = false;
        this.name = "";
        this.tmpName = "-";
      } else {
        this.errorFlag = 6;
        this.getBoot().show();
      }
    },
    async copyTmp(name) {
      let response = await fetch(`/event/all`, this.options('GET', { name: name }));
      this.isGet = true;
      this.events = (await response.json());
      for (var i in this.events) {
        if (!this.editForm[i]) this.editForm[i] = {}
        this.editForm[i].isDisabled = true;
      }
    },
    async addEvent() {
      if (this.addForm.name !== "" &&  this.addForm.src !== "") {
        if (this.addForm.name.length > 50) {
            // Слишком длинное имя
          this.errorFlag = 0;
          this.getBoot().show();
        } else if (!Number.isFinite(this.addForm.time) || this.addForm.time < 0) {
          this.errorFlag = 1;
          this.getBoot().show();
        } else {
            // correct
          this.editForm.push({ isDisabled: true });
          this.events.push(this.addForm);
          this.addForm = { name: "", src: "", type: 0, time: 15, isActive: true }
        }
      } else {
          // Нулевые поля для события 
        this.errorFlag = 5;
        this.getBoot().show();
      }
    },
    async editEvent(index) {
      this.editForm[index].isDisabled = false;
    },
    async saveEvent(index) {
      this.editForm[index].isDisabled = true;
    },
    async delEvent(index) {
      this.editForm[index].isDisabled = true;
      this.editForm[index].isDeleted = true;
      this.events.splice(index, 1);
      this.editForm.splice(index, 1);
    },
    async saveChanges() {
      if (this.events[0] === undefined) {
        this.events[0] = {
          name: "empty", src: "empty", type: 0, time: 1, isActive: true
        }
      } 
      for (let i in this.events) {
        this.events[i].canview = this.canView;
        this.events[i].isprivate = !this.canEdit;
        this.events[i].openedtmp = this.openedTmp;
      }
      let response = await fetch(`/event/save`, this.options('PATCH', this.events));
      console.log(response);
    },
    async sendTemplate() {
      if (this.specProg) {
        this.breakProg = '-';
        this.lunchProg = '-';
      }
      await fetch(`/event/send`, this.options('PUT', { 
          name: this.nameProg, 
          comment: this.commProg, 
          stud_name: this.studProg, 
          break_name: this.breakProg, 
          lunch_name: this.lunchProg, 
          screen: this.screenProg, 
          date: this.dateProg, 
          isSpec: this.specProg
        }));
    },
    async moveEvent(move, index) {
      let id1 = index;
      let id2 = null;
      if (move === "down" && id1 !== this.events.length-1)  id2 = id1++;
      if (move === "up" && id1 !==0)  id2 = id1--;
      if (id2 !== null) {
        this.correctArr(this.events, [id1, id2])
      }
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
    triggerStupid() {
      this.errorFlag = -1;
    }
  },
  mounted() {
    this.allTmp();
  }
}
</script>