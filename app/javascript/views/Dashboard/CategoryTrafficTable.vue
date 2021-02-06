<template>
  <div class="card">
    <div class="card-header border-0">
      <div class="row align-items-center">
        <div class="col">
          <h3 class="mb-0">Category Rate</h3>
        </div>
        <div class="col text-right">
          <!-- <base-button size="sm" type="primary">See all</base-button> -->
        </div>
      </div>
    </div>

    <div class="table-responsive">
      <base-table thead-classes="thead-light"
                  :data="tableData">
        <template slot="columns">
          <th>Referral</th>
          <th>Visitors</th>
          <th></th>
        </template>

        <template slot-scope="{row}">
          <th scope="row">
            {{row.name}}
          </th>
          <td>
            {{ row.expenses_amount | yen }}
          </td>
          <td>
            <div class="d-flex align-items-center">
              <span class="mr-2">{{row.use_rate}}%</span>
              <base-progress class="pt-0"
                             :show-percentage="false"
                             :value="Number(row.use_rate)"
              />
            </div>
          </td>
        </template>

      </base-table>
    </div>

  </div>
</template>
<script>
  import moment from "moment";

  export default {
    name: 'social-traffic-table',
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
