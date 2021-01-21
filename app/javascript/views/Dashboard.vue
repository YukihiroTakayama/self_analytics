<template>
  <div>
    <base-header
      type="gradient-success"
      class="pb-6 pb-8 pt-5 pt-md-8"
    >
      <!-- Card stats -->
      <div class="row">
        <div class="col-xl-3 col-lg-6">
          <stats-card
            title="balance"
            type="gradient-red"
            :sub-title="balance | yen"
            icon="ni ni-active-40"
            class="mb-4 mb-xl-0"
          >
            <template slot="footer">
              <span class="text-success mr-2"><i class="fa fa-arrow-up" /> 3.48%</span>
              <span class="text-nowrap">Since last month</span>
            </template>
          </stats-card>
        </div>
        <div class="col-xl-3 col-lg-6">
          <stats-card
            title="income"
            type="gradient-orange"
            :sub-title="total_income | yen"
            icon="ni ni-chart-pie-35"
            class="mb-4 mb-xl-0"
          >
            <template slot="footer">
              <span class="text-success mr-2"><i class="fa fa-arrow-up" /> 12.18%</span>
              <span class="text-nowrap">Since last month</span>
            </template>
          </stats-card>
        </div>
        <div class="col-xl-3 col-lg-6">
          <stats-card
            title="expense"
            type="gradient-green"
            :sub-title="total_expense | yen"
            icon="ni ni-money-coins"
            class="mb-4 mb-xl-0"
          >
            <template slot="footer">
              <span class="text-danger mr-2"><i class="fa fa-arrow-down" /> 5.72%</span>
              <span class="text-nowrap">Since last month</span>
            </template>
          </stats-card>
        </div>
        <div class="col-xl-3 col-lg-6">
          <stats-card
            title="Performance"
            type="gradient-info"
            :sub-title="amount | yen"
            icon="ni ni-chart-bar-32"
            class="mb-4 mb-xl-0"
          >
            <template slot="footer">
              <span class="text-success mr-2"><i class="fa fa-arrow-up" /> 54.8%</span>
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
          <card
            type="default"
            header-classes="bg-transparent"
          >
            <div
              slot="header"
              class="row align-items-center"
            >
              <div class="col-xl-3">
                <h6 class="text-light text-uppercase ls-1 mb-1">
                  Overview
                </h6>
                <h5 class="h3 text-white mb-0">
                  Sales value
                </h5>
              </div>
              <div class="col">
                <ul class="nav nav-pills justify-content-end">
                  <li class="nav-item mr-2 mr-md-0">
                    <div class="nav-link py-2 px-3">
                      <span class="d-none d-md-block">
                        <i
                          class="ni ni-bold-left"
                          @click.prevent="prevYear()"
                        />
                        {{ current_month | year }}
                        <i
                          class="ni ni-bold-right"
                          @click.prevent="nextYear()"
                        />
                      </span>
                      <span class="d-md-none">
                        <i
                          class="ni ni-bold-left"
                          @click.prevent="prevYear()"
                        />
                        {{ current_month | year }}
                        <i
                          class="ni ni-bold-right"
                          @click.prevent="nextYear()"
                        />
                      </span>
                    </div>
                  </li>
                  <li class="nav-item mr-2 mr-md-0">
                    <a class="nav-link py-2 px-3">
                      <span class="d-none d-md-block">
                        <i
                          class="ni ni-bold-left"
                          @click.prevent="prevMonth()"
                        />
                        {{ current_month | month }}
                        <i
                          class="ni ni-bold-right"
                          @click.prevent="nextMonth()"
                        />
                      </span>
                      <span class="d-md-none">
                        <i
                          class="ni ni-bold-left"
                          @click.prevent="prevMonth()"
                        />
                        {{ current_month | month }}
                        <i
                          class="ni ni-bold-right"
                          @click.prevent="nextMonth()"
                        />
                      </span>
                    </a>
                  </li>
                  <li class="nav-item mr-2 mr-md-0">
                    <a
                      class="nav-link py-2 px-3 btn"
                      :class="{active: lineChart.activeIndex === 0}"
                      @click.prevent="setChart(0)"
                    >
                      <span class="d-none d-md-block">Day</span>
                      <span class="d-md-none">D</span>
                    </a>
                  </li>
                  <li class="nav-item">
                    <a
                      class="nav-link py-2 px-3 btn"
                      :class="{active: lineChart.activeIndex === 1}"
                      @click.prevent="setChart(1)"
                    >
                      <span class="d-none d-md-block">Week</span>
                      <span class="d-md-none">W</span>
                    </a>
                  </li>
                  <li class="nav-item">
                    <a
                      class="nav-link py-2 px-3 btn"
                      href="#"
                      :class="{active: lineChart.activeIndex === 2}"
                      @click.prevent="setChart(2)"
                    >
                      <span class="d-none d-md-block">Month</span>
                      <span class="d-md-none">M</span>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
            <line-chart
              ref="bigChart"
              :height="350"
              :chart-data="lineChart.chartData"
              :extra-options="lineChart.extraOptions"
            />
          </card>
        </div>

        <div class="col-xl-4">
          <card
            type="default"
            header-classes="bg-transparent"
          >
            <div
              slot="header"
              class="row align-items-center"
            >
              <div class="col">
                <h6 class="text-uppercase text-muted ls-1 mb-1">
                  Performance
                </h6>
                <h5 class="h3 text-white mb-0">
                  Total orders
                </h5>
              </div>
            </div>

            <pie-chart
              ref="pieChart"
              :height="350"
              :chart-data="pieChart.chartData"
              :extra-options="pieChart.extraOptions"
            />

            <!-- <bar-chart
                                :height="350"
                                ref="barChart"
                                :chart-data="redBarChart.chartData"
                        >
                        </bar-chart> -->
          </card>
        </div>
      </div>
      <!-- End charts-->

      <!--Tables-->
      <div class="row mt-5">
        <div class="col-xl-8 mb-5 mb-xl-0">
          <page-visits-table
            :table-data="tableData"
            :columns="columns"
          />
        </div>
        <div class="col-xl-4">
          <social-traffic-table />
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
import PieChart from '../components/Charts/PieChart.js';

// Tables
import SocialTrafficTable from './Dashboard/SocialTrafficTable';
import PageVisitsTable from './Dashboard/PageVisitsTable';

import axios from 'axios';
import moment from 'moment';

export default {
  components: {
    LineChart,
    BarChart,
    PieChart,
    PageVisitsTable,
    SocialTrafficTable,
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
        return '+' + number.toLocaleString();
      } else {
        return number.toLocaleString();
      }
    }
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
      current_month: new Date(),
      balance: 0,
      total_income: 0,
      total_expense: 0,
      tableData: [],
      columns: [
        { key: 'transaction_date', name: '日付' },
        { key: 'content', name: '内容' },
        { key: 'large_category_name', name: '大項目' },
        { key: 'medium_category_name', name: '中項目' },
        { key: 'price', name: '金額' },
      ],
      amount: 0
    };
  },
  mounted() {
    this.setChart(0);
  },
  methods: {
    setChart(index) {
      let year = this.current_month.getFullYear();
      let month = this.current_month.getMonth() + 1;

      axios
        .get('/api/v1/charts', {
          params: {
            x_axis: index,
            year: year,
            month: month
          }
        })
        .then(response => {
          let data = response.data;
          this.lineChart.chartData = data.line_chart;
          this.pieChart.chartData = data.pie_chart_data;
          this.lineChart.activeIndex = index;
          this.current_month = new Date(data.year, data.month - 1);
          this.balance = data.balance;
          this.total_income = data.total_income;
          this.total_expense = data.total_expense * -1;
          this.tableData = data.transaction_list;
          this.amount = data.amount;
        });
    },
    nextYear() {
      this.current_month.setYear(this.current_month.getFullYear() + 1);
      this.setChart(this.lineChart.activeIndex);
    },
    prevYear() {
      this.current_month.setYear(this.current_month.getFullYear() - 1);
      this.setChart(this.lineChart.activeIndex);
    },
    nextMonth() {
      this.current_month.setMonth(this.current_month.getMonth() + 1);
      this.setChart(this.lineChart.activeIndex);
    },
    prevMonth() {
      this.current_month.setMonth(this.current_month.getMonth() - 1);
      this.setChart(this.lineChart.activeIndex);
    }
  }
};
</script>
<style></style>
