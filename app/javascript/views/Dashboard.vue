<template>
    <div>
        <base-header type="gradient-success" class="pb-6 pb-8 pt-5 pt-md-8">
            <!-- Card stats -->
            <div class="row">
                <div class="col-xl-3 col-lg-3">
                    <stats-card title="balance"
                                type="gradient-red"
                                :sub-title="balance | yen"
                                icon="ni ni-active-40"
                                class="mb-4 mb-xl-0"
                    >
                        <template slot="footer">
                            <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 3.48%</span>
                            <span class="text-nowrap">Since last month</span>
                        </template>
                    </stats-card>
                </div>
                <div class="col-xl-3 col-lg-3">
                    <stats-card title="income"
                                type="gradient-orange"
                                :sub-title="total_income | yen"
                                icon="ni ni-chart-pie-35"
                                class="mb-4 mb-xl-0"
                    >

                        <template slot="footer">
                            <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 12.18%</span>
                            <span class="text-nowrap">Since last month</span>
                        </template>
                    </stats-card>
                </div>
                <div class="col-xl-3 col-lg-3">
                    <stats-card title="expense"
                                type="gradient-green"
                                :sub-title="total_expense | yen"
                                icon="ni ni-money-coins"
                                class="mb-4 mb-xl-0"
                    >

                        <template slot="footer">
                            <span class="text-danger mr-2"><i class="fa fa-arrow-down"></i> 5.72%</span>
                            <span class="text-nowrap">Since last month</span>
                        </template>
                    </stats-card>

                </div>
                <div class="col-xl-3 col-lg-3">
                    <stats-card title="brought forward"
                                type="gradient-info"
                                :sub-title="amount | yen"
                                icon="ni ni-chart-bar-32"
                                class="mb-4 mb-xl-0"
                    >

                        <template slot="footer">
                            <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 54.8%</span>
                            <span class="text-nowrap">Since last month</span>
                        </template>
                    </stats-card>
                </div>
            </div>
        </base-header>

        <!--Charts-->
        <div class="container-fluid mt--7">
            <div class="row">
                <div class="col-xl-8 mb-5 mb-xl-0">
                    <card type="default" header-classes="bg-transparent">
                        <div slot="header" class="row align-items-center">
                            <div class="col-xl-3">
                                <h5 class="h3 text-white mb-0">Balance Chart</h5>
                            </div>
                            <div class="col">
                                <ul class="nav nav-pills justify-content-end">
                                    <li class="nav-item mr-2 mr-md-0">
                                        <div class="nav-link py-2 px-3">
                                            <span class="d-none d-md-block">
                                              <i class="ni ni-bold-left" @click.prevent="prevYear()"></i>
                                              {{ current_month | year }}
                                              <i class="ni ni-bold-right" @click.prevent="nextYear()"></i>
                                            </span>
                                            <span class="d-md-none">
                                              <i class="ni ni-bold-left" @click.prevent="prevYear()"></i>
                                              {{ current_month | year }}
                                              <i class="ni ni-bold-right" @click.prevent="nextYear()"></i>
                                            </span>
                                        </div>
                                    </li>
                                    <li class="nav-item mr-2 mr-md-0">
                                        <a class="nav-link py-2 px-3">
                                            <span class="d-none d-md-block">
                                              <i class="ni ni-bold-left" @click.prevent="prevMonth()"></i>
                                              {{ current_month | month }}
                                              <i class="ni ni-bold-right" @click.prevent="nextMonth()"></i>
                                            </span>
                                            <span class="d-md-none">
                                              <i class="ni ni-bold-left" @click.prevent="prevMonth()"></i>
                                              {{ current_month | month }}
                                              <i class="ni ni-bold-right" @click.prevent="nextMonth()"></i>
                                            </span>
                                        </a>
                                    </li>
                                    <li class="nav-item mr-2 mr-md-0">
                                        <a class="nav-link py-2 px-3 btn"
                                           :class="{active: lineChart.activeIndex === 0}"
                                           @click.prevent="setChart(0)">
                                            <span class="d-none d-md-block">Day</span>
                                            <span class="d-md-none">D</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link py-2 px-3 btn"
                                           :class="{active: lineChart.activeIndex === 1}"
                                           @click.prevent="setChart(1)">
                                            <span class="d-none d-md-block">Week</span>
                                            <span class="d-md-none">W</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link py-2 px-3 btn"
                                           href="#"
                                           :class="{active: lineChart.activeIndex === 2}"
                                           @click.prevent="setChart(2)">
                                            <span class="d-none d-md-block">Month</span>
                                            <span class="d-md-none">M</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <v-progress-circular
                          v-if="lineChart.isLoading"
                          :size="70"
                          style="height: 350px; width: 877px;"
                          indeterminate
                          class="center"
                        ></v-progress-circular>
                        <line-chart
                          v-else
                          :height="350"
                          ref="bigChart"
                          :chart-data="lineChart.chartData"
                          :extra-options="lineChart.extraOptions"
                        ></line-chart>
                    </card>
                </div>

                <div class="col-xl-4">
                    <card type="default" header-classes="bg-transparent">
                        <div slot="header" class="row align-items-center">
                            <div class="col">
                                <h5 class="h3 text-white mb-0">Category Chart</h5>
                            </div>
                        </div>

                        <pie-chart
                          :height="350"
                          ref="pieChart"
                          :chart-data="pieChart.chartData"
                        ></pie-chart>
                    </card>
                </div>
            </div>
            <!-- End charts-->

            <!--Tables-->
            <div class="row mt-5">
                <div class="col-xl-8 mb-5 mb-xl-0">
                    <transaction-list-table
                      :table-data="transactionPagination.tableData"
                      :columns="columns"
                    >
                    </transaction-list-table>
                    <v-pagination
                      v-model="transactionPagination.page"
                      :length="transactionPagination.length"
                      prev-icon="ni ni-bold-left"
                      next-icon="ni ni-bold-right"
                    ></v-pagination>
                </div>
                <div class="col-xl-4">
                    <category-traffic-table
                      :table-data="categoryPagination.tableData"
                    ></category-traffic-table>
                    <v-pagination
                      v-model="categoryPagination.page"
                      :length="categoryPagination.length"
                      prev-icon="ni ni-bold-left"
                      next-icon="ni ni-bold-right"
                    ></v-pagination>
                </div>
            </div>
            <!--End tables-->
        </div>

    </div>
</template>
<script>
  // Charts
  import * as chartConfigs from '../components/Charts/config';
  import LineChart from '../components/Charts/LineChart';
  import PieChart from '../components/Charts/PieChart'

  // Tables
  import CategoryTrafficTable from './Dashboard/CategoryTrafficTable';
  import TransactionListTable from './Dashboard/TransactionListTable';

  import axios from 'axios';
  import moment from "moment";

  export default {
    components: {
      LineChart,
      PieChart,
      TransactionListTable,
      CategoryTrafficTable,
    },
    data() {
      return {
        lineChart: {
          allData: [
            [0, 20, 10, 30, 15, 40, 20, 60, 60],
            [0, 20, 5, 25, 10, 30, 15, 40, 40]
          ],
          activeIndex: 0,
          chartData: {
            datasets: [],
            labels: [],
          },
          extraOptions: chartConfigs.blueChartOptions,
          isLoading: true
        },
        pieChart: {
          chartData: {
            datasets: [{
                data: []
            }],
            labels: []
          },
          extraOptions: chartConfigs.pieChartOptions
        },
        balance: 0,
        total_income: 0,
        total_expense: 0,
        transactionList: [],
        tableData: [],
        transactionPagination: {
          page: 0,
          length: 0,
          tableData: []
        },
        categoryPagination: {
          page: 0,
          length: 0,
          tableData: []
        },
        columns: [
          { key: 'transaction_date', name: '日付' },
          { key: 'content', name: '内容' },
          { key: 'large_category_name', name: '大項目' },
          { key: 'medium_category_name', name: '中項目' },
          { key: 'price', name: '金額' },
        ],
        amount: 0,
        year: 0,
        month: 0,
        current_month: new Date,
        years: [],
        categories: [],
      };
    },
    methods: {
      setChart(index) {
        axios
          .get('/api/v1/charts', {
            params: {
              x_axis: index,
              year: this.year,
              month: this.month
            }
          })
          .then(response => {
            let data = response.data
            this.lineChart.chartData = data.line_chart;
            this.pieChart.chartData = data.pie_chart_data
            this.lineChart.activeIndex = index;
            this.balance = data.balance
            this.total_income = data.total_income
            this.total_expense = data.total_expense * -1
            this.transactionList = data.transaction_list
            this.amount = data.amount
            this.current_month = new Date(data.year, data.month - 1)
            this.years = data.years
            this.categories = data.categories
            this.transactionPagination.length = parseInt(this.transactionList.length / 5, 10)
            this.categoryPagination.length = parseInt(this.categories.length / 5, 10)
            this.transactionPagination.page = 1
            this.categoryPagination.page = 1
            this.lineChart.isLoading = false
          })
      },
      nextYear() {
        if (this.year < 0) {
          this.lineChart.isLoading = true
          this.year += 1
          this.setChart(this.lineChart.activeIndex)
        }
      },
      prevYear() {
        if (this.year !== (this.years.length - 1) * -1) {
          this.lineChart.isLoading = true
          this.year -= 1
          this.setChart(this.lineChart.activeIndex)
        }
      },
      nextMonth() {
        let current_month = new Date
        let isCurrentMonth = this.current_month.getMonth() === current_month.getMonth() + 1 && this.current_month.getYear() === current_month.getYear()
        if (this.current_month.getMonth() !== 11 && !isCurrentMonth)  {
          this.lineChart.isLoading = true
          this.month += 1
          this.setChart(this.lineChart.activeIndex)
        }
      },
      prevMonth() {
        if (this.current_month.getMonth() !== 0) {
          this.lineChart.isLoading = true
          this.month -= 1
          this.setChart(this.lineChart.activeIndex)
        }
      },
    },
    mounted() {
      this.setChart(0);
    },
    watch: {
      'transactionPagination.page': function() {
        let i = 4 * (this.transactionPagination.page - 1)
        this.transactionPagination.tableData = this.transactionList.slice((0 + i), (5 + i))
        console.log(true)
      },
      'categoryPagination.page': function() {
        let i = 4 * (this.categoryPagination.page - 1)
        this.categoryPagination.tableData = this.categories.slice((0 + i), (5 + i))
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
        if (Math.sign(number) === 1) {
          return '+' + number.toLocaleString() + '円'
        } else {
          return number.toLocaleString() + '円'
        }
      }
    }
  };
</script>
<style></style>
