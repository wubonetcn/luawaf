<template>
  <div>
    <Card>
      <p slot="title">通用防护</p>
      <Form :model="general" :label-width="120">
        <Row>
          <Col span="6">
            <FormItem label="默认UA检查">
              <i-switch v-model="general.blackUaGeneralSwitch" size="large">
                <span slot="open">On</span>
                <span slot="close">Off</span>
              </i-switch>
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem label="默认URL检查">
              <i-switch v-model="general.blackUrlGeneralSwitch" size="large">
                <span slot="open">On</span>
                <span slot="close">Off</span>
              </i-switch>
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem label="默认GET请求检查">
              <i-switch v-model="general.blackGetArgsGeneralSwitch" size="large">
                <span slot="open">On</span>
                <span slot="close">Off</span>
              </i-switch>
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem label="默认POST请求检查">
              <i-switch v-model="general.blackPostArgsGeneralSwitch" size="large">
                <span slot="open">On</span>
                <span slot="close">Off</span>
              </i-switch>
            </FormItem>
          </Col>
        </Row>
        <Row>

          <Col span="6">
            <FormItem label="默认Cookies检查">
              <i-switch v-model="general.blackCookieArgsUrlGeneralSwitch" size="large">
                <span slot="open">On</span>
                <span slot="close">Off</span>
              </i-switch>
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem label="默认扫描器检查">
              <i-switch v-model="general.blackScannerGeneralSwitch" size="large">
                <span slot="open">On</span>
                <span slot="close">Off</span>
              </i-switch>
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem label="使用AI引擎">
              <i-switch v-model="general.aiSwitch" size="large">
                <span slot="open">On</span>
                <span slot="close">Off</span>
              </i-switch>
            </FormItem>
          </Col>
        </Row>
        <FormItem label="IP非法请求超阈值封禁">
          <i-switch v-model="general.illegalRequestRetryBlockSwitch" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="IP非法请求阈值(次/分)">
          <Input v-model="general.illegalRequestRetryMaxLimit" type="number" number
                 placeholder="次数"></Input>
        </FormItem>
        <FormItem label="IP非法请求超阈值封禁时间(秒)">
          <Input v-model="general.illegalRequestRetryBlockTime" type="number" number
                 placeholder="秒"></Input>
        </FormItem>
        <FormItem>
          <Button type="primary" @click="saveGeneral">保存</Button>
        </FormItem>
      </Form>
    </Card>
  </div>
</template>

<script>
export default {
  name: 'home',
  data: function () {
    return {
      general: {
        illegalRequestRetryBlockSwitch: false,
        illegalRequestRetryMaxLimit: 6,
        illegalRequestRetryBlockTime: 180,
        blackIpGeneralSwitch: true,
        blackUaGeneralSwitch: true,
        blackUrlGeneralSwitch: true,
        blackGetArgsGeneralSwitch: true,
        blackPostArgsGeneralSwitch: true,
        blackCookieArgsUrlGeneralSwitch: true,
        blackScannerGeneralSwitch: true,
        aiSwitch: false
      }
    }
  },
  methods: {
    getGeneral () {
    },
    saveGeneral () {
    }
  }
}
</script>

<style scoped>

</style>
