<template>
  <div>
    <Card :bordered="false">
      <p slot="title">分析</p>
      <Form :model="queryAnalyticsCondition" :label-width="50" label-position="left">
        <Row :gutter="50">
          <Col span="6">
            <FormItem label="日期">
              <DatePicker type="daterange" placeholder="自定义日期查询" v-model="queryDateRangeList"
                          @on-change="queryConditionChange"></DatePicker>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem>
              <Button type="info" @click="getAnalytics">查询</Button>
              <Button style="margin-left: 5px" @click="cleanQueryAnalyticsCondition">清空查询条件</Button>
            </FormItem>
          </Col>
        </Row>
      </Form>
      <div style="margin-top: 10px">
        <Table border :columns="analyticsListColumns" :data="analytics.analytics_list"></Table>
      </div>
      <div style="margin-top: 10px">
        <Page :total="analytics.order_total_num" :current="currentPageNum" show-elevator @on-change="pageChange"/>
      </div>
    </Card>
  </div>
</template>

<script>
import Axios from '@/libs/api.request'

export default {
  name: 'analytics',
  data () {
    return {
      queryDate: '',
      queryDateRangeList: [],
      queryAnalyticsCondition: {
        offset: 0,
        start_date: '',
        end_date: ''
      },
      currentPageNum: 1,
      analytics: {},
      analyticsListColumns: [
        {
          title: '事件ID',
          key: 'id'
        },
        {
          title: '时间',
          key: 'time'
        },
        {
          title: '源IP',
          key: 'origin_ip'
        },
        {
          title: '请求方法',
          key: 'methods'
        },
        {
          title: '请求URI',
          key: 'uri'
        },
        {
          title: 'UA',
          key: 'ua'
        },
        {
          title: '二级事件名称',
          key: 'event'
        },
        {
          title: '一级事件名称',
          key: 'tag'
        },
        {
          title: '触发规则',
          key: 'rule'
        }
      ]
    }
  },
  mounted () {
    const today = new Date()
    today.setTime(today.getTime())
    let month = today.getMonth() + 1
    let date = today.getDate()
    if (month < 10) month = '0' + month
    if (date < 10) date = '0' + date
    const todayStr = today.getFullYear() + '-' + month + '-' + date
    const tomorrow = new Date()
    tomorrow.setTime(tomorrow.getTime() + 24 * 60 * 60 * 1000)
    let tomorrowMonth = tomorrow.getMonth() + 1
    let tomorrowDate = tomorrow.getDate()
    if (tomorrowMonth < 10) tomorrowMonth = '0' + tomorrowMonth
    if (tomorrowDate < 10) tomorrowDate = '0' + tomorrowDate
    const tomorrowStr = tomorrow.getFullYear() + '-' + tomorrowMonth + '-' + tomorrowDate
    this.queryAnalyticsCondition.start_date = todayStr
    this.queryAnalyticsCondition.end_date = tomorrowStr
    // this.getAnalytics()
  },
  methods: {
    pageChange (currentPageNum) {
      this.queryAnalyticsCondition.offset = (currentPageNum - 1) * 10
      this.currentPageNum = currentPageNum
      this.getAnalytics()
    },
    getAnalytics () {
      this.queryAnalyticsCondition.token = this.$store.state.user.token
      Axios.request({
        url: '',
        data: this.queryAnalyticsCondition,
        method: 'post',
        headers: {
          'Content-Type': 'application/json'
        }
      }).then(res => {
        if (res.data.status === 'fail') {
          this.$Notice.error({
            title: res.data.message
          })
          return
        }
        this.analytics = res.data
        if (!res.data.analytics_list) {
          this.analytics.analytics_list = []
        }
      })
    },
    queryConditionChange (dateRange) {
      this.queryAnalyticsCondition.start_date = dateRange[0]
      this.queryAnalyticsCondition.end_date = dateRange[1]
      this.queryDateRangeList[0] = dateRange[0]
      this.queryDateRangeList[1] = dateRange[1]
    },
    cleanQueryAnalyticsCondition () {
      const today = new Date()
      today.setTime(today.getTime())
      let month = today.getMonth() + 1
      let date = today.getDate()
      if (month < 10) month = '0' + month
      if (date < 10) date = '0' + date
      const todayStr = today.getFullYear() + '-' + month + '-' + date
      const tomorrow = new Date()
      tomorrow.setTime(tomorrow.getTime() + 24 * 60 * 60 * 1000)
      let tomorrowMonth = tomorrow.getMonth() + 1
      let tomorrowDate = tomorrow.getDate()
      if (tomorrowMonth < 10) tomorrowMonth = '0' + tomorrowMonth
      if (tomorrowDate < 10) tomorrowDate = '0' + tomorrowDate
      const tomorrowStr = tomorrow.getFullYear() + '-' + tomorrowMonth + '-' + tomorrowDate
      this.queryAnalyticsCondition.start_date = todayStr
      this.queryAnalyticsCondition.end_date = tomorrowStr
      this.queryAnalyticsCondition.offset = 0
      this.getAnalytics()
    }
  }
}
</script>

<style scoped>

</style>
