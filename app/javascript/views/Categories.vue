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
                <div v-for="(category, index) in categories" class="col-xl-3 col-lg-3">
                    <stats-card :title="category.name" type="gradient-info" :sub-title="category.name" class="mb-4 mb-xl-0">
                        <template slot="icon">
                          <div class="icon icon-shape text-white rounded-circle shadow btn"
                               :style="`background-color: ${category.color};`"
                               @click="dialogOpen(index)"
                               >
                          </div>
                        </template>
                        <template slot="footer">
                            <span class="text-success mr-2"><i class="fa fa-arrow-up"></i> 54.8%</span>
                            <span class="text-nowrap">Since last month</span>
                        </template>
                    </stats-card>
                    <div class="text-center" data-app>
                        <v-dialog v-model="category.dialog" width="300">
                            <v-card>
                                <v-card-title class="headline grey lighten-2">
                                    Privacy Policy
                                </v-card-title>
                                <v-color-picker
                                    v-model="category.color"
                                    dot-size="25"
                                    swatches-max-height="200"
                                ></v-color-picker>
                                <v-card-actions>
                                    <v-spacer></v-spacer>
                                    <v-btn color="primary" text @click="category.dialog = false">
                                        キャンセル
                                    </v-btn>
                                    <v-btn color="primary" text @click="updateColor(index)">
                                        更新
                                    </v-btn>
                                </v-card-actions>
                            </v-card>
                        </v-dialog>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import moment from "moment";

export default {
    components: {},
    data() {
        return {
            categories: [],
        };
    },
    methods: {
        setCategories() {
            axios
                .get('/api/v1/categories')
                .then(response => {
                    let data = response.data;
                    this.categories = data.categories;
                })
        },
        dialogOpen(index) {
            this.categories[index].dialog = true
        },
        updateColor(index) {
            let category = this.categories[index]
            axios
                .patch('/api/v1/categories/' + category.id, {
                    color: category.color
                })
            category.dialog = false
        }
    },
    mounted() {
        this.setCategories();
    },
};
</script>
<style></style>