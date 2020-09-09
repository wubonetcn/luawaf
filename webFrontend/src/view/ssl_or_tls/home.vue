<template>
  <div>
    <Card>
      <p slot="title">SSL/TLS管理</p>
      <Form :model="ssl" :label-width="100">
        <FormItem label="启用RSA证书">
          <i-switch v-model="ssl.rsaSwitch" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="RSA Cert">
          <Input v-model="ssl.rsaCert" type="textarea" placeholder="RSA数字证书"></Input>
        </FormItem>
        <FormItem label="RSA Key">
          <Input v-model="ssl.rsaKey" type="textarea" placeholder="RSA密钥"></Input>
        </FormItem>
        <FormItem label="启用SM2证书">
          <i-switch v-model="ssl.sm2Switch" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="SM2 Cert">
          <Input v-model="ssl.sm2Cert" type="textarea" placeholder="SM2数字证书"></Input>
        </FormItem>
        <FormItem label="SM2 Key">
          <Input v-model="ssl.sm2Key" type="textarea" placeholder="SM2密钥"></Input>
        </FormItem>
        <FormItem label="强制SSL">
          <i-switch v-model="ssl.forceSslSwitch" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem>
          <Button type="primary" @click="saveSsl">保存</Button>
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
      ssl: {
        rsaCert: '',
        rsaKey: '',
        sm2Cert: '',
        sm2Key: '',
        rsaSwitch: false,
        sm2Switch: false,
        forceSslSwitch: false
      }
    }
  },
  methods: {
    getSsl () {
    },
    saveSsl () {
      if (this.ssl.forceSslSwitch && !this.ssl.rsaSwitch && !this.ssl.sm2Switch) {
        this.$Notice.error({
          title: '设置强制SSL失败',
          desc: '请至少开启RAS/SM2中的一个'
        })
      }
    }
  }
}
</script>

<style scoped>

</style>
