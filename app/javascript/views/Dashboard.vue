<template>
    <div>
        <base-header type="gradient-success" class="pb-6 pb-8 pt-5 pt-md-8">
            <!-- Card stats -->
            <div class="row">
                <div class="col-xl-3 col-lg-6">
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
                <div class="col-xl-3 col-lg-6">
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
                <div class="col-xl-3 col-lg-6">
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
                <div class="col-xl-3 col-lg-6">
                    <stats-card title="Performance"
                                type="gradient-info"
                                sub-title="49,65%"
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
                <div class="col-xl-12 mb-5 mb-xl-0">
                    <card type="default" header-classes="bg-transparent">
                        <div slot="header" class="row align-items-center">
                            <div class="col">
                                <h6 class="text-light text-uppercase ls-1 mb-1">Overview</h6>
                                <h5 class="h3 text-white mb-0">Sales value</h5>
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
                                           :class="{active: bigLineChart.activeIndex === 0}"
                                           @click.prevent="setChart(0)">
                                            <span class="d-none d-md-block">Day</span>
                                            <span class="d-md-none">D</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link py-2 px-3 btn"
                                           :class="{active: bigLineChart.activeIndex === 1}"
                                           @click.prevent="setChart(1)">
                                            <span class="d-none d-md-block">Week</span>
                                            <span class="d-md-none">W</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link py-2 px-3 btn"
                                           href="#"
                                           :class="{active: bigLineChart.activeIndex === 2}"
                                           @click.prevent="setChart(2)">
                                            <span class="d-none d-md-block">Month</span>
                                            <span class="d-md-none">M</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <line-chart
                                :height="350"
                                ref="bigChart"
                                :chart-data="bigLineChart.chartData"
                                :extra-options="bigLineChart.extraOptions"
                        >
                        </line-chart>

                    </card>
                </div>

                <!-- <div class="col-xl-4">
                    <card header-classes="bg-transparent">
                        <div slot="header" class="row align-items-center">
                            <div class="col">
                                <h6 class="text-uppercase text-muted ls-1 mb-1">Performance</h6>
                                <h5 class="h3 mb-0">Total orders</h5>
                            </div>
                        </div>

                        <bar-chart
                                :height="350"
                                ref="barChart"
                                :chart-data="redBarChart.chartData"
                        >
                        </bar-chart>
                    </card>
                </div> -->
            </div>
            <!-- End charts-->

            <!--Tables-->
            <div class="row mt-5">
                <div class="col-xl-8 mb-5 mb-xl-0">
                    <page-visits-table></page-visits-table>
                </div>
                <div class="col-xl-4">
                    <social-traffic-table></social-traffic-table>
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
  import BarChart from '../components/Charts/BarChart';

  // Tables
  import SocialTrafficTable from './Dashboard/SocialTrafficTable';
  import PageVisitsTable from './Dashboard/PageVisitsTable';

  import axios from 'axios';
  import moment from "moment";

  export default {
    components: {
      LineChart,
      BarChart,
      PageVisitsTable,
      SocialTrafficTable,
    },
    data() {
      return {
        bigLineChart: {
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
        },
        current_month: new Date(),
        balance: 0,
        total_income: 0,
        total_expense: 0,
      };
    },
    methods: {
      setChart(index) {
        let year = this.current_month.getFullYear()
        let month = this.current_month.getMonth() + 1

        axios
          .get('/api/v1/charts', {
            params: {
              x_axis: index,
              year: year,
              month: month
            }
          })
          .then(response => {
            let data = response.data
            this.bigLineChart.chartData = data.line_chart;
            this.bigLineChart.activeIndex = index;
            this.current_month = new Date(data.year, data.month - 1)
            this.balance = data.balance
            this.total_income = data.total_income
            this.total_expense = data.total_expense * -1
          })
      },
      nextYear() {
        this.current_month.setYear(this.current_month.getFullYear() + 1);
        this.setChart(this.bigLineChart.activeIndex)
      },
      prevYear() {
        this.current_month.setYear(this.current_month.getFullYear() - 1);
        this.setChart(this.bigLineChart.activeIndex)
      },
      nextMonth() {
        this.current_month.setMonth(this.current_month.getMonth() + 1);
        this.setChart(this.bigLineChart.activeIndex)
      },
      prevMonth() {
        this.current_month.setMonth(this.current_month.getMonth() - 1);
        this.setChart(this.bigLineChart.activeIndex)
      }
    },
    mounted() {
      this.setChart(0);
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
          return '+' + number.toLocaleString()
        } else {
          return number.toLocaleString()
        }
      }
    }
  };
</script>
<style></style>
