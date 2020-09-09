<template>
  <div>
    <Row :gutter="20">
      <i-col :xs="12" :md="8" :lg="6" v-for="(infor, i) in inforCardData" :key="`infor-${i}`"
             style="height: 120px;padding-bottom: 10px;">
        <infor-card shadow :color="infor.color" :icon="infor.icon" :icon-size="36">
          <count-to :end="infor.count" count-class="count-style"/>
          <p>{{ infor.title }}</p>
        </infor-card>
      </i-col>
    </Row>
    <Row :gutter="20" style="margin-top: 10px;">
      <i-col :md="24" :lg="12" style="margin-bottom: 20px;">
        <Card shadow>
          <chart-bar style="height: 300px;" :value="dailyIndependentVisitorsBarData" text="每天独立访问者"/>
        </Card>
      </i-col>
      <i-col :md="24" :lg="12" style="margin-bottom: 20px;">
        <Card shadow>
          <chart-pie style="height: 300px;" :value="attackTypePieData" text="今日攻击类型分布"></chart-pie>
        </Card>
      </i-col>
    </Row>
    <!-- <Row>
       <Card shadow>
         <example style="height: 310px;"/>
       </Card>
     </Row>-->
  </div>
</template>

<script>
import InforCard from '_c/info-card'
import CountTo from '_c/count-to'
import { ChartPie, ChartBar } from '_c/charts'
import Example from './example.vue'

export default {
  name: 'home',
  components: {
    InforCard,
    CountTo,
    ChartPie,
    ChartBar,
    Example
  },
  data () {
    return {
      inforCardData: [
        { title: '今日独立访问者', icon: 'md-people', count: 23, color: '#2d8cf0' },
        { title: '今日总请求数', icon: 'md-desktop', count: 232, color: '#19be6b' },
        { title: '今日已缓存的请求', icon: 'md-cloud-done', count: 56, color: '#ff9900' },
        { title: '今日总攻击数', icon: 'md-flash', count: 142, color: '#ed3f14' }
      ],
      attackTypePieData: [
        { value: 335, name: 'CC攻击' },
        { value: 310, name: '黑名单URL' },
        { value: 234, name: '路径穿越' },
        { value: 135, name: '敏感文件读取' },
        { value: 135, name: 'SQL注入' },
        { value: 135, name: 'XSS' },
        { value: 1548, name: '恶意文件上传' },
        { value: 135, name: '机器人' },
        { value: 135, name: '扫描器' }
      ],
      dailyIndependentVisitorsBarData: {
        '07/16': 253,
        '07/17': 280,
        '07/18': 239,
        '07/19': 295,
        '07/20': 431,
        '07/21': 462,
        '07/22': 264
      }
    }
  },
  mounted () {
    //
  }
}
</script>

<style lang="less">
  .count-style {
    font-size: 50px;
  }
</style>
