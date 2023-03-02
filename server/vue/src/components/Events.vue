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

    <!-- <script>
      var SuccessToast = new bootstrap.Toast(document.getElementById("ToastSuccess"));
      SuccessToast.show();

      var ErrorToast = new bootstrap.Toast(document.getElementById("ToastError"));
      ErrorToast.show();

      var InfoToast = new bootstrap.Toast(document.getElementById("ToastInfo"));
      InfoToast.show();
    </script> -->

    <!--Группировка модалки-->
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
            <button class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button class="btn btn-success" href="#" @click="saveChanges" onclick="location.reload(); return;">Сохранить</button>
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
            <button class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
            <button @click="delTmp(tmpName)" onclick="location.reload(); return;" class="btn btn-danger">Удалить</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Send -->
    <div class="modal fade" id="SendModerModal" tabindex="-1" data-bs-backdrop="static">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5"> Отправить форму на модерацию </h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form>
              <div class="mb-3">
                <label for="recipient-name" class="col-form-label">Название:</label>
                <input v-model="nameProg" type="text" class="form-control" id="recipient-name" placeholder="Заголовок трансляции"/>
              </div>
              <div class="mb-3">
                <label for="message-text" class="col-form-label">Комментарий:</label>
                <textarea v-model="commProg" class="form-control" id="message-text" placeholder="Не обязательно"></textarea>
              </div>
            </form>
          </div>
          <div class="modal-footer">

            <div v-if="!specProg" class="d-flex w-100 justify-content-between align-items-center gap-1">
              Пары:
              <select v-model="studProg" class="form-select form-select-sm w-75" aria-label=".form-select-sm example">
                <option value="-" selected>- Нет изменений -</option>
                <option v-for="tmp in tmpList" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
              </select>
            </div>
            <div v-if="!specProg" class="d-flex w-100 justify-content-between align-items-center gap-1">
              Перерыв:
              <select v-model="breakProg" class="form-select form-select-sm w-75" aria-label=".form-select-sm example">
                <option value="-" selected>- Нет изменений -</option>
                <option v-for="tmp in tmpList" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
              </select>
            </div>
            <div v-if="!specProg" class="d-flex w-100 justify-content-between align-items-center gap-1">
              Обед:
              <select v-model="lunchProg" class="form-select form-select-sm w-75" aria-label=".form-select-sm example">
                <option value="-" selected>- Нет изменений -</option>
                <option v-for="tmp in tmpList" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
              </select>
            </div>
            <div v-if="specProg" class="d-flex w-100 justify-content-between align-items-center gap-1">
              Особый:
              <select v-model="studProg" class="form-select form-select-sm w-75" aria-label=".form-select-sm example">
                <option value="-" selected>- Нет изменений -</option>
                <option v-for="tmp in tmpList" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
              </select>
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



    <div class="container">
      <h6 class="text p-0 mt-4"> Работа с трансляцией </h6>

      <div class="content">
        <div style="margin-right: 0">

          <div class="d-flex justify-content-between">
              <div class="input-group">
                <!-- v-for="tmp in this.tmpList" -->
                  <select v-model="tmpName" class="form-select" id="inputGroupSelect04">
                      <option value="-" selected>- Выберите -</option>
                      <option v-for="tmp in tmpList" :value="tmp.name" > {{ tmp.name }}  ( by: {{ tmp.author }} ) - upd: {{ tmp.last_modify }} </option>
                  </select>
                  <button @click="getTmp(tmpName)" class="btn btn-outline-secondary" type="button">Открыть</button>
              </div>

              <div class="d-flex justify-content-end ms-2">
                  <div v-if="canEdit || isAuthor" class="btn-group w-auto" role="group">
                      <!-- Button trigger Save modal -->
                      <button type="button" class="btn btn-outline-success"  @click="checkIssues">Сохранить</button>
                      <!-- Button trigger Delete modal -->
                      <button v-if="isAuthor" type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#ModalDelete" >Удалить</button>
                  </div>
                  <!-- Button trigger Send modal -->
                  <button type="button" class="btn btn-success ms-2 w-auto" @click="sendForm()"> Отправить </button>
              </div>
          </div>

          <div class="input-group mt-2">
              <input v-model="name" id="name" name="name" type="text" class="form-control" placeholder="Имя нового шаблона">
              <button @click="addTmp(name, 'empty', [])" class="btn btn-outline-secondary" type="button">Создать пустой</button>
              <button @click="addTmp(name, 'default', [])" class="btn btn-outline-secondary" type="button">Создать по умолчанию</button>
              <button @click="addTmp(name, 'copy', this.events)" class="btn btn-outline-secondary" type="button">Создать копию</button>
          </div>

          <!-- SWITCHES -->
          <div v-if="isGet" class="d-flex w-100 justify-content-start align-items-center gap-3 mt-1">
            <!-- SWITCH - Видимость -->
            <div v-if="isAuthor" class="form-check form-switch mt-1">
                <input class="form-check-input" type="checkbox" role="switch" v-model="canView" :checked="canView">
                <label class="form-check-label" for="flexSwitchCheckDefault">Разрешить просматривать другим</label>
            </div>
            <!-- SWITCH - Реактирование -->
            <div v-if="canView && isAuthor" class="form-check form-switch mt-1">
                <input class="form-check-input" type="checkbox" role="switch" v-model="canEdit" :checked="canEdit">
                <label class="form-check-label" for="flexSwitchCheckDefault">Разрешить редактировать другим</label>
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

        <!--ФОРМА ДОБАВЛЕНИЯ!!!!!!!!!-->
        <div v-if="canEdit || isAuthor" class="row gx-3 gy-2 align-items-center p-1">
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
            <label class="visually-hidden" for="specificSizeInputGroupUsername3">Username</label>
            <input v-model="addForm.src" type="text" class="form-control" id="specificSizeInputGroupUsername3" placeholder="Ссылка" required>
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
            <button @click="addEvent()" type="submit" class="btn btn-success">Добавить</button>
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

      succCallback: [],     // Колбек - успешно
      errCallback: [],      // Колбек - ошибка 
      sendCallback: [],     // Модалка формы отправки

      successMessage: null, // Текст успешной операции
      errorMessage: null,   // Текст ошибки

      currentTime: null,
      // ${process.env.API_URL}
      format: /[`!@#$%^&*()+=\[\]{};':"\\|,.<>\/?~]/
    }
  },
  methods: {
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
    async allTmp() {
      this.succCallback = new bootstrap.Toast(document.getElementById("ToastSuccess"));
      this.sendCallback = new bootstrap.Modal(document.getElementById('SendModerModal'));
      this.errCallback = new bootstrap.Toast(document.getElementById("ToastError"));

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

      let date_ob = new Date();
      let dd = ("0" + date_ob.getDate()).slice(-2);
      let mm = ("0" + (date_ob.getMonth() + 1)).slice(-2);
      let yyyy = date_ob.getFullYear();
      let minDate = yyyy + '-' + mm + '-' + dd;
      let maxDate = (Number(yyyy) + 1) + '-' + mm + '-' + dd;

      document.getElementById('startDate').min = minDate;
      document.getElementById('startDate').max = maxDate;
      document.getElementById('startDate').value = minDate;
      this.dateProg = minDate;
    },
    async getTmp(name) {
      await this.getTime();
      if (name !== "-") {
        let response = await fetch(`/event/all`, this.options('PATCH', { name: name }));
        this.events = (await response.json());
      
        if (this.events[0].name === "none" && this.events[0].src === "none"){
          this.events = [];
          this.errorMessage = 'Данный шаблон был удален его автором. \nСвяжитесь с автором шаблона для уточнения информации.';
          this.errCallback.show();
        } else {
          this.canView = this.events[0].canview;
          this.canEdit = !this.events[0].isprivate;
          this.isAuthor = this.events[0].isauthor;

          if (this.events[0].name === "undef" && this.events[0].src === "undef") {
            this.events = [];
          }
          this.openedTmp = name;
          this.isGet = true;
            
          for (let i in this.events) {
            if (!this.editForm[i]) this.editForm[i] = {}
            this.editForm[i].isDisabled = true;
          }
        }
      } else {
        this.errorMessage = 'Пожалуйста, выберите шаблон, который хотите открыть.';
        this.errCallback.show();
      }
    },
    async addTmp(name, tmp_type, events) {
      await this.getTime();

      if (this.format.test(name)) {
        this.errorMessage = 'Имя шаблона не должно содержать специальных символов: \n' + this.format;
        this.errCallback.show();
        return;
      }


      if (this.name.length > 30) {
        this.errorMessage = 'Полученно слишком длинное наименование шаблона. \nПроверьте, пожалуйста, правильность введённых данных \nРазрешено символов: 30. Получено:' + this.name.length ;
        this.errCallback.show();
      } else if (name !== "") {
        if (tmp_type === 'empty' || tmp_type === 'default' || tmp_type === 'copy') {
          let callback = await fetch(`/event/addtmp`, this.options('PUT', { name: name, tmp_type: tmp_type, events: events }));
          let responseAdd = await fetch(`/event/alltmp`, {});
          this.tmpList = (await responseAdd.json());
          this.tmpName = name;
          this.name = "";
          this.successMessage = '';
          if ((await callback.json()).typecall === 'success') {
            switch (tmp_type) {
              case 'copy':
                this.successMessage = 'Шаблон был успешно скопирован под именем: \"' + name + '\".'; 
                break;
              case 'default':
                this.successMessage = 'Шаблон \"' + name + '\" был успешно создан.';
                break;
              case 'empty':
                this.successMessage = 'Шаблон \"' + name + '\" был успешно создан.';
                break;
            }
            this.succCallback.show();
          } else {
            this.errorMessage = 'Шаблон c именем: \"' + name + '\" уже существует. Придумайте другое.';
            this.errCallback.show();
          }
          await this.getTmp(name);
        }
      } else {
        this.errorMessage = 'Заполните имя нового шаблона!';
        this.errCallback.show();
      }
    },
    async delTmp(name) {
      await this.getTime();
      if (name !== "-") {
        await fetch(`/event/deltmp`, this.options('DELETE', { name: name }));
        this.openedTmp = "";
        this.isGet = false;
        this.tmpName = "";
        this.canEdit = false;
        this.canView = false;
        this.isAuthor = false;
        this.name = "";
        this.successMessage = 'Шаблон "' + this.tmpName + '" был успешно удален.';
        this.succCallback.show();
        this.tmpName = "-";
      } else {
        this.errorMessage = 'Выберите шаблон, который хотите удалить.';
        this.errCallback.show();
      }
    },
    async addEvent() {
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
        } else if (this.addForm.name.trim() === '') {
          this.errorMessage = 'Имя события не должно состоять только из пробелов.';
          this.errCallback.show();
        } else {
          // ----- CORRECT PROCESSING ----

            // if (Number(this.addForm.type) === 1) {
            //     // Обработка файла загрузки
            //
            // }

            // Обработка URL-адреса
            this.editForm.push({isDisabled: true});
            this.events.push(this.addForm);
            this.addForm = {name: "", src: "", type: 0, time: 15, isActive: true}

        }
      } else {
          // Нулевые поля для события 
        this.errorMessage = 'Пожалуйста, заполните все поля перед добавлением.';
        this.errCallback.show();
      }
    },
    async editEvent(index) {
      this.editForm[index].isDisabled = false;
    },
    async saveEvent(index) {
      await this.getTime();
      if (this.events[index].src === '') {
        this.errorMessage = 'Не определен ресурс события. ';
        this.errCallback.show();
      } else if (this.format.test(this.events[index].name)) {
        this.errorMessage = 'Имя события не должно содержать специальных символов: \n' + this.format;
        this.errCallback.show();
      } else if (this.events[index].name === '') {
        this.errorMessage = 'Не определено имя события.';
        this.errCallback.show();
      } else if (this.events[index].name.trim() === '') {
        this.errorMessage = 'Имя события не должно состоять только из пробелов.';
        this.errCallback.show();
      } else if (this.events[index].time === '') {
        this.errorMessage = 'Не определено время.';
        this.errCallback.show();
      } else if (Number(this.events[index].time) <= 0) {
        this.errorMessage = 'Время не может быть отрицательным.';
        this.errCallback.show();
      } else if (Number(this.events[index].type) !== 0 && Number(this.events[index].type) !== 1 && Number(this.events[index].type) !== 2) {
        this.errorMessage = 'System: обнаружена попытка сломать форму. Уведомление о ваших действиях направлено администратору.';
        this.errCallback.show();
      } else if (this.events[index].name.length <= 50) {
        this.editForm[index].isDisabled = true;
      }  else {
        this.errorMessage = 'Полученно слишком длинное наименование события. \nРазрешено символов: 50. Получено: ' + this.events[index].name.length;
        this.errCallback.show();
      }
    },
    async delEvent(index) {
      this.editForm[index].isDisabled = true;
      this.editForm[index].isDeleted = true;
      this.events.splice(index, 1);
      this.editForm.splice(index, 1);
    },
    async checkIssues() {
      await this.getTime();
      for (let form in this.editForm) {
        if (!this.editForm[form].isDisabled) {
          this.errorMessage = 'Невозможно сохранить изменения, пока идет редактирование.';
          this.errCallback.show();
          return;
        }
      }
      let saveCallback = new bootstrap.Modal(document.getElementById('ModalSave'));
      saveCallback.show();
    },
    async saveChanges() {
      await this.getTime();
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
    async sendForm() {
      this.sendCallback.show();
    },
    async sendTemplate() {
      await this.getTime();
      if (this.specProg) {
        this.breakProg = '-';
        this.lunchProg = '-';
      }

      let response = await fetch(`/event/send`, this.options('PUT', {
          name: this.nameProg, 
          comment: this.commProg, 
          stud_name: this.studProg, 
          break_name: this.breakProg, 
          lunch_name: this.lunchProg, 
          screen: this.screenProg, 
          date: this.dateProg, 
          isSpec: this.specProg
        }
      ));
      
      this.errorMessage = (await response.json()).message;
        // Ошибка при некорректных полях
      if (this.errorMessage !== '-') {
        this.errCallback.show();
      } else {
          // Окошко "отправлено успешно"
        this.successMessage = 'Успешно отправлено на модерацию.';
        this.succCallback.show();
          // Скрыть мочалку отправки
        this.sendCallback.hide();
          // Обнуление для не дублирования при нескольких запросах подряд
        this.nameProg = ''
        this.commProg = ''
        this.studProg = '-'
        this.breakProg = '-'
        this.lunchProg = '-'
        this.screenProg = '1'
      }
    },
    async moveEvent(move, index) {
      let id1 = index;
      let id2 = null;
      if (move === "down" && id1 !== this.events.length-1)  id2 = id1++;
      if (move === "up" && id1 !== 0)  id2 = id1--;
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

    // ---- FILE UPLOAD METHODS ----
    // onFileChange(e) {
    //   let files = e.target.files || e.dataTransfer.files;
    //   if (!files.length)
    //     return;
    //   this.createImage(files[0]);
    // },
    // createImage(file) {
    //   let image = new Image();
    //   let reader = new FileReader();
    //   let vm = this;
    //
    //   reader.onload = (e) => {
    //     vm.image = e.target.result;
    //   };
    //   reader.readAsDataURL(file);
    //   console.log(reader.result);
    //   this.addForm.src = reader
    // },
    // removeImage: function (e) {
    //   this.addForm.src = '';
    // },
    // ------ END FILE UPLOAD ------

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
    this.allTmp();
  }
}
</script>