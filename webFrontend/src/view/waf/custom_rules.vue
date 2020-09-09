<template>
  <div>
    <Card>
      <p slot="title">自定义规则</p>
      <Form :model="customRule" :label-width="100">
        <h4 style="margin-left: 5px;margin-bottom: 5px">文件上传后缀黑名单</h4>
        <FormItem label="功能开关">
          <i-switch v-model="customRule.blackUploadExt.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="正则">
          <Input v-model="customRule.blackUploadExt.reg" type="textarea" placeholder="正则"></Input>
        </FormItem>
        <FormItem label="触发返回状态码">
          <Select v-model="customRule.blackUploadExt.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>
        <Divider/>
        <h4 style="margin-left: 5px;margin-bottom: 5px">白名单URL</h4>
        <FormItem label="功能开关">
          <i-switch v-model="customRule.whiteUrl.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="正则">
          <Input v-model="customRule.whiteUrl.reg" type="textarea" placeholder="正则"></Input>
        </FormItem>
        <Divider/>
        <h4 style="margin-left: 5px;margin-bottom: 5px">黑名单URL</h4>
        <FormItem label="功能开关">
          <i-switch v-model="customRule.blackUrl.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="正则">
          <Input v-model="customRule.blackUrl.reg" type="textarea" placeholder="正则"></Input>
        </FormItem>
        <FormItem label="触发返回状态码">
          <Select v-model="customRule.blackUrl.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>

        <Divider/>
        <h4 style="margin-left: 5px;margin-bottom: 5px">黑名单GET参数</h4>
        <FormItem label="功能开关">
          <i-switch v-model="customRule.blackGetArgs.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="正则">
          <Input v-model="customRule.blackGetArgs.reg" type="textarea" placeholder="正则"></Input>
        </FormItem>
        <FormItem label="触发返回状态码">
          <Select v-model="customRule.blackGetArgs.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>

        <Divider/>
        <h4 style="margin-left: 5px;margin-bottom: 5px">黑名单POST参数</h4>
        <FormItem label="功能开关">
          <i-switch v-model="customRule.blackPostArgs.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="正则">
          <Input v-model="customRule.blackPostArgs.reg" type="textarea" placeholder="正则"></Input>
        </FormItem>
        <FormItem label="触发返回状态码">
          <Select v-model="customRule.blackPostArgs.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>

        <Divider/>
        <h4 style="margin-left: 5px;margin-bottom: 5px">黑名单Cookie参数</h4>
        <FormItem label="功能开关">
          <i-switch v-model="customRule.blackCookieArgs.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="正则">
          <Input v-model="customRule.blackCookieArgs.reg" type="textarea" placeholder="正则"></Input>
        </FormItem>
        <FormItem label="触发返回状态码">
          <Select v-model="customRule.blackCookieArgs.statusCode" style="width:300px">
            <Option v-for="statusCode in statusCodeList" :value="statusCode.code" :key="statusCode.code">{{
              statusCode.code }} {{statusCode.name}}
            </Option>
          </Select>
        </FormItem>

        <FormItem>
          <Button type="primary" @click="saveCustomRule">保存</Button>
        </FormItem>
      </Form>
    </Card>
  </div>
</template>

<script>
export default {
  name: 'custom_rules',
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
      customRule: {
        blackUploadExt: {
          reg: '',
          statusCode: 404,
          open: false
        },
        whiteUrl: {
          reg: '',
          open: false
        },
        blackUrl: {
          reg: '',
          statusCode: 404,
          open: false
        },
        blackGetArgs: {
          reg: '',
          statusCode: 404,
          open: false
        },
        blackPostArgs: {
          reg: '',
          statusCode: 404,
          open: false
        },
        blackCookieArgs: {
          reg: '',
          statusCode: 404,
          open: false
        }
      },
      editRuleSwitch: false
    }
  },
  methods: {
    getCustomRule () {
    },
    saveCustomRule () {
    }
  }
}
</script>

<style scoped>

</style>
