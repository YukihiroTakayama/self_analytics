<template>
  <div class="text-center" data-app>
    <v-dialog
      v-model="category.dialog"
      persistent
      max-width="600px"
    >
      <v-card>
        <v-card-title>
          <span class="headline">{{ category.name }}</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col
                cols="12"
                sm="6"
                md="6"
              >
                <pie-chart
                  ref="pieChart"
                  :chart-data="category.pie_chart_data"
                  style="height: 200px;"
                ></pie-chart>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="6"
              >
                <v-color-picker
                  v-model="category.color"
                  dot-size="25"
                  swatches-max-height="200"
                  hide-inputs
                ></v-color-picker>
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
                  v-model="category.expense_price"
                  class="centered-input"
                  :value="category.expense_price"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="1"
              ><div class="v-text-field">円</div>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="4"
              ><div class="v-text-field">使用率</div>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="7"
              >
                <v-text-field
                  v-model="category.use_rate"
                  class="centered-input"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="1"
              ><div class="v-text-field">%</div>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="4"
              ><div class="v-text-field">予算</div>
              </v-col>
              <v-col
                cols="12"
                sm="6"
                md="7"
              >
                <v-text-field
                  v-model="category.budget"
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
              color="blue darken-1"
              text
              @click="dialogClose()"
            >
              Close
            </v-btn>
            <v-btn
              color="blue darken-1"
              text
              @click="updateCategory()"
            >
              Save
            </v-btn>
          </slot>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
  import axios from 'axios';
  import PieChart from '../components/Charts/PieChart'

  export default {
    name: 'category-dialog',
    components: {
      PieChart
    },
    data: () => ({
    }),
    props: {
      category: {
        type: Object,
        default: () => ({}),
      }
    },
    methods: {
      dialogOpen() {
        this.category.dialog = true
      },
      updateCategory() {
        axios
          .patch('/api/v1/categories/' + this.category.id, {
            category: {
              color: this.category.color,
              budget_attributes: {
                price: this.category.budget
              }
            }
          })
          .then(response => {
            // let data = response.data
            // this.category = data.category
            this.dialogClose()
            this.$parent.setCategories()
          })
      },
      dialogClose() {
        this.category.dialog = false
      }
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