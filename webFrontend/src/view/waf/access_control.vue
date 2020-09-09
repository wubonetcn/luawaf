<template>
  <div>
    <Card>
      <p slot="title">访问控制</p>
      <Row>
        <Col :span="20">
          <h3>IP黑白名单
            <Tag>未开启</Tag>
          </h3>
          <p>允许或者禁止某些 IP 或者 IP 段的访问，支持 IP 黑名单和 IP 白名单。</p>
        </Col>
        <Col :span="4">
          <Button type="primary" @click="editBlackAndWhiteListConfig">管理</Button>
        </Col>
      </Row>
      <Divider/>
      <Row>
        <Col :span="20">
          <h3>地区访问限制
            <Tag>未开启</Tag>
          </h3>
          <p>允许或禁止特定区域的终端用户对网站资源的访问，支持按国家/地区、省份、运营商等维度进行配置。</p>
        </Col>
        <Col :span="4">
          <Button type="primary" @click="editRegionalAccessRestrictionsConfig">管理</Button>
        </Col>
      </Row>
      <Divider/>
      <Row>
        <Col :span="20">
          <h3>IP访问限制
            <Tag>未开启</Tag>
          </h3>
          <p>可以针对单个IP在单位周期时间内的访问频率设置一定的阈值，将超过该阈值的IP的访问进行直接拦截，从而达到访问限制的目的。</p>
        </Col>
        <Col :span="4">
          <Button type="primary" @click="editIpLimitConfig">管理</Button>
        </Col>
      </Row>
      <Divider/>
      <Row>
        <Col :span="20">
          <h3>User-Agent访问限制
            <Tag>未开启</Tag>
          </h3>
          <p>允许和禁止特定的浏览器或者带有特殊 User-Agent 标识的专属客户端进行访问。</p>
        </Col>
        <Col :span="4">
          <Button type="primary" @click="editUaConfig">管理</Button>
        </Col>
      </Row>
    </Card>

    <Modal v-model="editBlackAndWhiteListConfigSwitch" title="IP黑白名单" ok-text="保存" cancel-text="取消编辑"
           @on-ok="saveBlackAndWhiteListConfig"
           :width="900">
      <Form :model="blackAndWhiteListConfig" :label-width="100">
        <FormItem label="客户端配置">
          <RadioGroup v-model="blackAndWhiteListConfig.clientConfiguration">
            <Radio label="关闭IP黑白名单" border></Radio>
            <Radio label="开启IP黑名单" border></Radio>
            <Radio label="开启IP白名单" border></Radio>
          </RadioGroup>
        </FormItem>
        <FormItem label="IP黑名单" v-if="blackAndWhiteListConfig.clientConfiguration === '开启IP黑名单'">
          <Input v-model="blackAndWhiteListConfig.blackIp" placeholder="每行一个IP地址" type="textarea"></Input>
          <p>支持*通配符如IPv4地址10.11.12.*，将禁止或允许10.11.12.0 ~
            10.11.12.255范围的IP访问;如IPv6地址10::11:*，将禁止或允许10::11:0~10::11:ffff范围的IP访问;IP黑白名单上限100 条；</p>
        </FormItem>
        <FormItem label="触发返回状态码" v-if="blackAndWhiteListConfig.clientConfiguration === '开启IP黑名单'">
          <Select v-model="blackAndWhiteListConfig.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>
        <FormItem label="IP白名单" v-if="blackAndWhiteListConfig.clientConfiguration === '开启IP白名单'">
          <Input v-model="blackAndWhiteListConfig.whiteIp" placeholder="每行一个IP地址" type="textarea"></Input>
          <p>支持*通配符如IPv4地址10.11.12.*，将禁止或允许10.11.12.0 ~
            10.11.12.255范围的IP访问;如IPv6地址10::11:*，将禁止或允许10::11:0~10::11:ffff范围的IP访问;IP黑白名单上限100 条；</p>
        </FormItem>
      </Form>
    </Modal>

    <Modal v-model="editRegionalAccessRestrictionsConfigSwitch" title="地区访问限制" ok-text="保存" cancel-text="取消编辑"
           @on-ok="saveRegionalAccessRestrictionsConfig">
      <Form :model="regionalAccessRestrictionsConfig" :label-width="100">
        <FormItem label="地区配置">
          <RadioGroup v-model="regionalAccessRestrictionsConfig.regionalAllocation">
            <Radio label="不启用" border></Radio>
            <Radio label="启用白名单" border></Radio>
            <Radio label="启用黑名单" border></Radio>
          </RadioGroup>
        </FormItem>
        <FormItem label="添加地区" v-if="regionalAccessRestrictionsConfig.regionalAllocation !== '不启用'">
          <Row>
            <Col :span="16">
              <Cascader :data="regionList" v-model="pendingRegionItem"></Cascader>
            </Col>
            <Col :span="8">
              <Button style="margin-left: 5px" type="primary" :disabled="!pendingRegionItem[0]" @click="addRegion">添加
              </Button>
            </Col>
          </Row>
          <div v-if="regionalAccessRestrictionsConfig.regionalAllocation === '启用白名单'">
            <Tag v-for="(origin,index) in regionalAccessRestrictionsConfig.whiteRegion" :key="index" type="border"
                 closable color="primary"
                 @on-close="deleteOrigin(origin)">{{origin.country+origin.province}}
            </Tag>
          </div>
          <div v-if="regionalAccessRestrictionsConfig.regionalAllocation === '启用黑名单'">
            <Tag v-for="(origin,index) in regionalAccessRestrictionsConfig.blackRegion" :key="index" type="border"
                 closable color="primary"
                 @on-close="deleteOrigin(origin)">{{origin.country+origin.province}}
            </Tag>
          </div>
        </FormItem>
        <FormItem label="触发返回状态码" v-if="regionalAccessRestrictionsConfig.regionalAllocation === '启用黑名单'">
          <Select v-model="regionalAccessRestrictionsConfig.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>
      </Form>
    </Modal>

    <Modal v-model="editUaConfigSwitch" title="User-Agent访问限制" ok-text="保存" cancel-text="取消编辑"
           @on-ok="saveUaConfig">
      <Form :model="uaConfig" :label-width="100">
        <FormItem label="客户端配置">
          <RadioGroup v-model="uaConfig.clientConfiguration">
            <Radio label="不启用" border></Radio>
            <Radio label="启用" border></Radio>
          </RadioGroup>
        </FormItem>
        <FormItem label="UA正则" v-if="uaConfig.clientConfiguration === '启用'">
          <Input v-model="uaConfig.reg" placeholder="UA正则" type="textarea"></Input>
          <p>匹配到则拒绝访问。</p>
        </FormItem>
        <FormItem label="触发返回状态码" v-if="uaConfig.clientConfiguration === '启用'">
          <Select v-model="uaConfig.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>
      </Form>
    </Modal>

    <Modal v-model="editIpLimitConfigSwitch" title="IP访问限制" ok-text="保存" cancel-text="取消编辑"
           @on-ok="saveUaConfig">
      <Form :model="ipLimitConfig" :label-width="100">
        <FormItem label="IP访问限制开关">
          <i-switch v-model="ipLimitConfig.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="触发返回状态码">
          <Select v-model="ipLimitConfig.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>
        <FormItem label="IP请求阈值(次/分)">
          <Input v-model="ipLimitConfig.limit" type="number" number
                 placeholder="次数"></Input>
        </FormItem>
        <FormItem label="IP请求超阈值封禁时间(秒)">
          <Input v-model="ipLimitConfig.blockTime" type="number" number
                 placeholder="秒"></Input>
        </FormItem>
      </Form>
    </Modal>

  </div>
</template>

<script>
export default {
  name: 'access_control',
  data: function () {
    return {
      statusCodeList: [
        {
          code: 205,
          name: 'Reset Content'
        },
        {
          code: 400,
          name: 'Bad Request'
        },
        {
          code: 401,
          name: 'Unauthorized'
        },
        {
          code: 403,
          name: 'Forbidden'
        },
        {
          code: 404,
          name: 'Not Found'
        },
        {
          code: 416,
          name: 'Requested range not satisfiable'
        },
        {
          code: 500,
          name: 'Internal Server Error'
        },
        {
          code: 501,
          name: 'Not Implemented'
        },
        {
          code: 502,
          name: 'Bad Gateway'
        },
        {
          code: 503,
          name: 'Service Unavailable'
        },
        {
          code: 504,
          name: 'Gateway Time-out'
        },
        {
          code: 505,
          name: 'HTTP Version not supported'
        }],
      editBlackAndWhiteListConfigSwitch: false,
      blackAndWhiteListConfig: {
        clientConfiguration: '关闭IP黑白名单',
        statusCode: 404,
        blackIp: '',
        whiteIp: ''
      },
      regionList: [
        {
          'value': '中国',
          'label': '中国',
          'children': [
            {
              'value': '北京市',
              'label': '北京市'
            },
            {
              'value': '天津市',
              'label': '天津市'
            },
            {
              'value': '上海市',
              'label': '上海市'
            },
            {
              'value': '重庆市',
              'label': '重庆市'
            },
            {
              'value': '河北省',
              'label': '河北省'
            },
            {
              'value': '山西省',
              'label': '山西省'
            },
            {
              'value': '辽宁省',
              'label': '辽宁省'
            },
            {
              'value': '吉林省',
              'label': '吉林省'
            },
            {
              'value': '黑龙江省',
              'label': '黑龙江省'
            },
            {
              'value': '江苏省',
              'label': '江苏省'
            },
            {
              'value': '浙江省',
              'label': '浙江省'
            },
            {
              'value': '安徽省',
              'label': '安徽省'
            },
            {
              'value': '福建省',
              'label': '福建省'
            },
            {
              'value': '江西省',
              'label': '江西省'
            },
            {
              'value': '山东省',
              'label': '山东省'
            },
            {
              'value': '河南省',
              'label': '河南省'
            },
            {
              'value': '湖北省',
              'label': '湖北省'
            },
            {
              'value': '湖南省',
              'label': '湖南省'
            },
            {
              'value': '广东省',
              'label': '广东省'
            },
            {
              'value': '海南省',
              'label': '海南省'
            },
            {
              'value': '四川省',
              'label': '四川省'
            },
            {
              'value': '贵州省',
              'label': '贵州省'
            },
            {
              'value': '云南省',
              'label': '云南省'
            },
            {
              'value': '陕西省',
              'label': '陕西省'
            },
            {
              'value': '甘肃省',
              'label': '甘肃省'
            },
            {
              'value': '青海省',
              'label': '青海省'
            },
            {
              'value': '台湾省',
              'label': '台湾省'
            },
            {
              'value': '内蒙古自治区',
              'label': '内蒙古自治区'
            },
            {
              'value': '广西壮族自治区',
              'label': '广西壮族自治区'
            },
            {
              'value': '西藏自治区',
              'label': '西藏自治区'
            },
            {
              'value': '宁夏回族自治区',
              'label': '宁夏回族自治区'
            },
            {
              'value': '新疆维吾尔自治区',
              'label': '新疆维吾尔自治区'
            },
            {
              'value': '香港特别行政区',
              'label': '香港特别行政区'
            },
            {
              'value': '澳门特别行政区',
              'label': '澳门特别行政区'
            }
          ]
        }, {
          'value': '韩国',
          'label': '韩国',
          'children': [{
            'value': '首尔',
            'label': '首尔'
          },
          {
            'value': '其他',
            'label': '其他'
          }
          ]
        }],
      regionalAccessRestrictionsConfig: {
        statusCode: 404,
        regionalAllocation: '不启用',
        blackRegion: [],
        whiteRegion: []
      },
      editRegionalAccessRestrictionsConfigSwitch: false,
      pendingRegionItem: [],
      editUaConfigSwitch: false,
      uaConfig: {
        clientConfiguration: '不启用',
        reg: '',
        statusCode: 404
      },
      editIpLimitConfigSwitch: false,
      ipLimitConfig: {
        open: true,
        statusCode: 404,
        limit: 120,
        blockTime: 300
      }
    }
  },
  methods: {
    editIpLimitConfig () {
      this.editIpLimitConfigSwitch = true
    },
    editBlackAndWhiteListConfig () {
      this.editBlackAndWhiteListConfigSwitch = true
    },
    editRegionalAccessRestrictionsConfig () {
      this.editRegionalAccessRestrictionsConfigSwitch = true
    },
    editUaConfig () {
      this.editUaConfigSwitch = true
    },
    addRegion () {
      if (this.regionalAccessRestrictionsConfig.regionalAllocation === '启用白名单') {
        this.regionalAccessRestrictionsConfig.whiteRegion.push({
          country: this.pendingRegionItem[0],
          province: this.pendingRegionItem[1]
        })
        this.pendingRegionItem = []
      }
      if (this.regionalAccessRestrictionsConfig.regionalAllocation === '启用黑名单') {
        this.regionalAccessRestrictionsConfig.blackRegion.push({
          country: this.pendingRegionItem[0],
          province: this.pendingRegionItem[1]
        })
        this.pendingRegionItem = []
      }
    },
    deleteOrigin (origin) {
      if (this.regionalAccessRestrictionsConfig.regionalAllocation === '启用白名单') {
        for (let i = 0; i < this.regionalAccessRestrictionsConfig.whiteRegion.length; i++) {
          if (this.regionalAccessRestrictionsConfig.whiteRegion[i].country === origin.country && this.regionalAccessRestrictionsConfig.whiteRegion[i].province === origin.province) {
            this.regionalAccessRestrictionsConfig.whiteRegion.splice(i, 1)
          }
        }
      }
      if (this.regionalAccessRestrictionsConfig.regionalAllocation === '启用黑名单') {
        for (let i = 0; i < this.regionalAccessRestrictionsConfig.blackRegion.length; i++) {
          if (this.regionalAccessRestrictionsConfig.blackRegion[i].country === origin.country && this.regionalAccessRestrictionsConfig.blackRegion[i].province === origin.province) {
            this.regionalAccessRestrictionsConfig.blackRegion.splice(i, 1)
          }
        }
      }
    },
    saveBlackAndWhiteListConfig () {
    },
    saveRegionalAccessRestrictionsConfig () {
    },
    saveUaConfig () {
    }
  }
}
</script>

<style scoped>

</style>
