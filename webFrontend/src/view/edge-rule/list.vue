<template>
  <div>
    <Card>
      <p slot="title">边缘规则</p>
      <Button type="info" @click="addEdgeRule">新增规则</Button>
      <div style="margin-top: 10px">
        <Table border :columns="edgeRuleListColumns" :data="edgeRuleList"></Table>
      </div>
    </Card>
    <Modal v-model="editEdgeRuleSwitch" title="编辑边缘规则" ok-text="保存" cancel-text="取消编辑"
           @on-ok="saveEdgeRule">
      <Form :model="edgeRule" :label-width="120" label-position="left">
        <FormItem label="边缘规则名称：">
          <Input v-model="edgeRule.name" placeholder="请输入边缘规则名称"></Input>
        </FormItem>
        <FormItem label="边缘规则函数：">
          <Input v-model="edgeRule.func" type="textarea" placeholder="请输入边缘规则函数"></Input>
        </FormItem>
        <FormItem label="启用">
          <i-switch v-model="edgeRule.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
      </Form>
    </Modal>
  </div>
</template>

<script>
export default {
  name: 'list',
  data: function () {
    return {
      edgeRuleListColumns: [
        {
          title: '名称',
          key: 'name'
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
                    this.editEdgeRule(params.row)
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
                    this.deleteEdgeRule(params)
                  }
                }
              }, '删除')
            ])
          }
        }
      ],
      edgeRuleList: [],
      editEdgeRuleSwitch: false,
      edgeRule: {
        name: '',
        func: '',
        open: false
      }
    }
  },
  methods: {
    addEdgeRule () {
      this.edgeRule = {}
      this.editEdgeRuleSwitch = true
    },
    editEdgeRule (edgeRule) {
      this.edgeRule = edgeRule
      this.editEdgeRuleSwitch = true
    },
    saveEdgeRule () {

    },
    deleteEdgeRule () {
    }
  }
}
</script>

<style scoped>

</style>
