<template>
  <div>
    <base-header type="gradient-success" class="pb-6 pb-8 pt-5 pt-md-8">
        <!-- Card stats -->
        <div class="row">
            <div class="col-xl-3 col-lg-3">
                <stats-card title="Total traffic" type="gradient-red" sub-title="350,897" icon="ni ni-active-40" class="mb-4 mb-xl-0">
                    <template slot="footer">
                        <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 3.48%</span>
                        <span class="text-nowrap">Since last month</span>
                    </template>
                </stats-card>
            </div>
            <div class="col-xl-3 col-lg-3">
                <stats-card title="Total traffic" type="gradient-orange" sub-title="2,356" icon="ni ni-chart-pie-35" class="mb-4 mb-xl-0">
                    <template slot="footer">
                        <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 12.18%</span>
                        <span class="text-nowrap">Since last month</span>
                    </template>
                </stats-card>
            </div>
            <div class="col-xl-3 col-lg-3">
                <stats-card title="Sales" type="gradient-green" sub-title="924" icon="ni ni-money-coins" class="mb-4 mb-xl-0">
                    <template slot="footer">
                        <span class="text-danger mr-2"><i class="fa fa-arrow-down"></i> 5.72%</span>
                        <span class="text-nowrap">Since last month</span>
                    </template>
                </stats-card>
            </div>
            <div class="col-xl-3 col-lg-3">
                <stats-card title="Performance" type="gradient-info" sub-title="49,65%" icon="ni ni-chart-bar-32" class="mb-4 mb-xl-0">
                    <template slot="footer">
                        <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 54.8%</span>
                        <span class="text-nowrap">Since last month</span>
                    </template>
                </stats-card>
            </div>
        </div>
    </base-header>
    <div class="container-fluid mt--7">
        <div class="row">
          <div class="col-xl-12 col-lg-12">
              <stats-card title="固定支出" type="gradient-red" :sub-title="fixedExpense.totalPrice  | yen" icon="ni ni-active-40" class="mb-4 mb-xl-0 shadow">
                  <template slot="footer">
                    <div class="row">
                      <div v-for="(expense, index) in fixedExpense.list" class="col-xl-3 col-lg-3">
                        <a @click="dialogOpen(expense)">
                          <stats-card :title="expense.large_category.name" type="gradient-info" :sub-title="expense.price | yen" class="mb-4 mb-xl-0 btn shadow">
                              <template slot="icon">
                                <div class="icon icon-shape text-white rounded-circle"
                                     :style="`background-color: ${expense.large_category.color};`">
                                </div>
                              </template>
                              <template slot="footer">
                                  <!-- <span :class="`text-success mr-2 text-${UseRateStatus(category)}`"><i class="fa fa-arrow-up"></i>{{ `${category.use_rate}%` }}</span>
                                  <span class="text-nowrap">Since last month</span> -->
                              </template>
                          </stats-card>
                        </a>
                        <expense-form-dialog :expense="expense" @setExpenses="setExpenses()"></expense-form-dialog>
                      </div>
                      <div class="col-xl-3 col-lg-3">
                        <a @click="dialogOpen(fixedExpense.initialExpense)">
                          <stats-card title="" type="gradient-red" sub-title="新規登録" icon="ni ni-fat-add" class="mb-4 mb-xl-0 btn shadow">
                          </stats-card>
                        </a>
                        <expense-form-dialog :expense="fixedExpense.initialExpense" @setExpenses="setExpenses()"></expense-form-dialog>
                      </div>
                    </div>
                  </template>
              </stats-card>
          </div>
          <div class="col-xl-12 col-lg-12">
              <stats-card title="予測支出" type="gradient-red" :sub-title="predictionExpense.totalPrice  | yen" icon="ni ni-active-40" class="mb-4 mb-xl-0 shadow">
                  <template slot="footer">
                    <div class="row">
                      <div v-for="(expense, index) in predictionExpense.list" class="col-xl-3 col-lg-3">
                        <a @click="dialogOpen(expense)">
                          <stats-card :title="expense.large_category.name" type="gradient-info" :sub-title="expense.price | yen" class="mb-4 mb-xl-0 btn shadow">
                              <template slot="icon">
                                <div class="icon icon-shape text-white rounded-circle"
                                     :style="`background-color: ${expense.large_category.color};`">
                                </div>
                              </template>
                              <template slot="footer">
                                  <!-- <span :class="`text-success mr-2 text-${UseRateStatus(category)}`"><i class="fa fa-arrow-up"></i>{{ `${category.use_rate}%` }}</span>
                                  <span class="text-nowrap">Since last month</span> -->
                              </template>
                          </stats-card>
                        </a>
                        <expense-form-dialog :expense="expense" @setExpenses="setExpenses()" :fixedFlag="false"></expense-form-dialog>
                      </div>
                      <div class="col-xl-3 col-lg-3">
                        <a @click="dialogOpen(predictionExpense.initialExpense)">
                          <stats-card title="" type="gradient-red" sub-title="新規登録" icon="ni ni-fat-add" class="mb-4 mb-xl-0 btn shadow">
                          </stats-card>
                        </a>
                        <expense-form-dialog :expense="predictionExpense.initialExpense" @setExpenses="setExpenses()" :fixedFlag="false"></expense-form-dialog>
                      </div>
                    </div>
                  </template>
              </stats-card>
          </div>
        </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  import moment from "moment";
  import ExpenseFormDialog from "../components/Dialog/ExpenseFormDialog";

  export default {
    components: {
      ExpenseFormDialog
    },
    data: () => ({
      fixedExpense: {
        list: [],
        totalPrice: 0,
        initialExpense: {
          id: '',
          content: '',
          price: 0,
          calculating_target_flag: true,
          dialog: false
        },
      },
      predictionExpense: {
        list: [],
        totalPrice: 0,
        initialExpense: {
          id: '',
          content: '',
          price: 0,
          calculating_target_flag: true,
          dialog: false
        },
      },
    }),
    mounted() {
      this.setExpenses();
    },
    methods: {
      setExpenses() {
        this.setFixedExpenses()
        this.setPredictionExpenses()
      },
      setFixedExpenses() {
        axios
          .get('/api/v1/fixed_expenses')
          .then(response => {
              let data = response.data;
              this.fixedExpense.list = data.fixed_expenses;
              this.fixedExpense.totalPrice = data.total_price;
              this.fixedExpense.initialExpense = {
                id: '',
                content: '',
                price: 0,
                calculating_target_flag: true,
                dialog: false
              }
          })
      },
      setPredictionExpenses() {
        axios
          .get('/api/v1/prediction_expenses')
          .then(response => {
              let data = response.data;
              this.predictionExpense.list = data.prediction_expenses;
              this.predictionExpense.totalPrice = data.total_price;
              this.predictionExpense.initialExpense = {
                id: '',
                content: '',
                price: 0,
                calculating_target_flag: true,
                dialog: false
              }
          })
      },
      dialogOpen(object) {
        object.dialog = true
      },
      test() {
        console.log(true)
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
    },
  }
</script>

<style>
  .btn {
    text-align: initial;
    vertical-align: initial;
    padding: initial;
  }
</style>
