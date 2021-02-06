<template>
  <div class="card">
    <div class="card-header border-0">
      <div class="row align-items-center">
        <div class="col">
          <h3 class="mb-0">Transaction List</h3>
        </div>
        <div class="col text-right">
          <!-- <a href="#!" class="btn btn-sm btn-primary">See all</a> -->
        </div>
      </div>
    </div>

    <div class="table-responsive">
      <base-table thead-classes="thead-light"
                  :data="tableData">
        <template slot="columns">
          <th scope="row" v-for="column in columns">{{ column.name }}</th>
        </template>

        <template slot-scope="{row}">
          <th scope="row" v-for="column in columns">
            {{row[column.key]}}
          </th>
        </template>

      </base-table>
    </div>
  </div>
</template>
<script>
  import moment from "moment";

  export default {
    name: 'transaction-list-table',
    data() {
      return {
      }
    },
    props: {
      tableData: {
        type: Array,
        default: () => [],
        description: 'Table data'
      },
      columns: {
        type: Array,
          default: () => [],
          description: 'Row columns'
      },
    },
    filters: {
      yen: function (number) {
        return number.toLocaleString() + '円'
      }
    }
  }
</script>
<style>
</style>
