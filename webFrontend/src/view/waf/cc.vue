<template>
  <div>
    <Card>
      <p slot="title">CC防护</p>
      <Button type="info" @click="addCC">新增规则</Button>
      <div style="margin-top: 10px">
        <Table border :columns="ccListColumns" :data="ccList"></Table>
      </div>
    </Card>
    <Modal v-model="editCCSwitch" title="编辑CC防护规则" ok-text="保存" cancel-text="取消编辑"
           @on-ok="saveCC">
      <Form :model="cc" :label-width="120" label-position="left">
        <FormItem label="URI：">
          <Input v-model="cc.uri" placeholder="/blog/my_first_blog.html"></Input>
        </FormItem>
        <FormItem label="IP访问限制开关">
          <i-switch v-model="cc.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="触发返回状态码">
          <Select v-model="cc.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>
        <FormItem label="IP请求阈值(次/分)">
          <Input v-model="cc.limit" type="number" number
                 placeholder="次数"></Input>
        </FormItem>
        <FormItem label="IP请求超阈值封禁时间(秒)">
          <Input v-model="cc.blockTime" type="number" number
                 placeholder="秒"></Input>
        </FormItem>
      </Form>
    </Modal>
  </div>
</template>

<script>
export default {
  name: 'cc',
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
      ccListColumns: [
        {
          title: 'URI',
          key: 'uri'
        },
        {
          title: 'IP请求阈值(次/分)',
          key: 'limit'
        },
        {
          title: '超阈值封禁时间',
          key: 'blockTime'
        },
        {
          title: '状态',
          key: 'open',
          render: (h, params) => {
            return h('div', [h('span', params.row.open ? '启用' : '未启用')
            ])
          }
        },
        {
          title: '操作',
          key: 'id',
          align: 'center',
          render: (h, params) => {
            return h('div', [
              h('Button', {
                props: {
                  type: 'primary',
                  size: 'small'
                },
                style: {
                  marginRight: '5px'
                },
                on: {
                  click: () => {
                    this.editCC(params.row)
                  }
                }
              }, '编辑'),
              h('Button', {
                props: {
                  type: 'error',
                  size: 'small'
                },
                style: {
                  marginRight: '5px'
                },
                on: {
                  click: () => {
                    this.deleteCC(params)
                  }
                }
              }, '删除')
            ])
          }
        }
      ],
      ccList: [],
      editCCSwitch: false,
      cc: {
        uri: '',
        open: true,
        statusCode: 404,
        limit: 120,
        blockTime: 300
      }
    }
  },
  methods: {
    addCC () {
      this.cc = {}
      this.editCCSwitch = true
    },
    editCC (cc) {
      this.cc = cc
      this.editCCSwitch = true
    },
    saveCC () {

    },
    deleteCC () {
    }
  }
}
</script>

<style scoped>

</style>
