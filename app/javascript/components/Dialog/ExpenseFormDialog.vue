<template>
  <div class="text-center" data-app>
    <v-dialog
      v-model="expense.dialog"
      persistent
      max-width="600px"
    >
      <v-card>
        <v-card-title>
          <span v-if="initialFlag" class="headline" style="margin-left: auto">新規固定費</span>
          <span v-else class="headline" style="margin-left: auto">固定費編集</span>
          <v-icon @click="dialogClose()" style="margin-left: auto" large>ni ni-fat-remove</v-icon>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col
                cols="12"
                sm="6"
                md="4"
              ><div class="v-text-field">カテゴリー</div>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="7"
              >
                <v-select
                  v-model="expense.large_category"
                  item-text="name"
                  item-value="id"
                  :items="categories"
                  label="カテゴリー"
                  class="centered-input"
                  return-object
                ></v-select>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="4"
              ><div class="v-text-field">内容</div>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="7"
              >
                <v-text-field
                  v-model="expense.content"
                  class="centered-input"
                ></v-text-field>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="4"
              ><div class="v-text-field">支出</div>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="7"
              >
                <v-text-field
                  v-model="expense.price"
                  class="centered-input"
                ></v-text-field>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="1"
              ><div class="v-text-field">円</div>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <slot name="button">
            <v-btn
              color="red darken-1"
              text
              @click="deleteExpense()"
              v-if="!initialFlag"
            >
              削除
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="createOrUpdateExpense()"
            >
              保存
            </v-btn>
          </slot>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    name: 'expense-form-dialog',
    components: {
    },
    data: () => ({
      categories: [],
      initialFlag: true
    }),
    props: {
      expense: {
        type: Object,
        default: () => ({}),
      },
      fixedFlag: {
        type: Boolean,
        default: true
      }
    },
    watch: {
      'expense.dialog': function(newValue) {
        if (newValue === true) {
          this.setCategories();
          this.initialFlag = this.isInitial()
        }
      },
    },
    methods: {
      dialogOpen() {
        this.expense.dialog = true
      },
      createOrUpdateExpense() {
        let path = '/api/v1/fixed_expenses/'
        if (!this.fixedFlag) {
          path = '/api/v1/prediction_expenses/'
        }
        axios
          .post(path, {
            expense: this.expense
          })
          .then(response => {
            this.dialogClose()
            this.$emit('setExpenses')
          })
      },
      setCategories() {
        axios
          .get('/api/v1/categories/items')
          .then(response => {
              let data = response.data;
              this.categories = data.items;
          })
      },
      dialogClose() {
        this.expense.dialog = false
      },
      deleteExpense() {
        let path = '/api/v1/fixed_expenses/'
        if (!this.fixedFlag) {
          path = '/api/v1/prediction_expenses/'
        }
        axios
          .delete(path + this.expense.id)
          .then(response => {
            this.dialogClose()
            this.$emit('setExpenses')
          })
      },
      isInitial() {
        return this.expense.id.length === 0
      },
    },
    filters: {
      month: function (date) {
        return moment(date).format('M月');
      },
      year: function (date) {
        return moment(date).format('YYYY年');
      },
      yen: function (number) {
        return number.toLocaleString() + '円'
      }
    }
  }
</script>
<style>
  .centered-input input {
    text-align: center
  }
</style>