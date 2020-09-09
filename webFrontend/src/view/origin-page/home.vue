<template>
  <div>
    <Card>
      <p slot="title">源站管理</p>
      <Form :model="origin" :label-width="100">
        <FormItem label="CNAME" v-if="origin.domainList[0]">
          <Input :value="origin.domainList[0] + '.node.edgeoceanwaf.com'" disabled></Input>
        </FormItem>
        <FormItem label="域名">
          <Tag v-for="(domain,index) in origin.domainList" :key="index" type="border" closable color="primary"
               @on-close="deleteDomain(domain)">{{domain}}
          </Tag>
          <Input v-model="pendingAddDomain" search enter-button="增加" @on-search="addDomain"
                 placeholder="域名"></Input>
        </FormItem>
        <FormItem label="源站">
          <Input v-model="origin.proxyPassUrl" placeholder="如http://origin.demo.com"></Input>
        </FormItem>
        <FormItem label="Websocket支持">
          <i-switch v-model="origin.websocket" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem label="使用了其它厂商CDN">
          <i-switch v-model="origin.useOtherCompanyCDNSwitch" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem>
          <Button type="primary" @click="saveOrigin">保存</Button>
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
      pendingAddDomain: '',
      origin: {
        domainList: [],
        proxyPassUrl: '',
        websocket: false,
        useOtherCompanyCDNSwitch: false
      }
    }
  },
  methods: {
    addDomain () {
      if (this.pendingAddDomain.length <= 0) {
        this.$Notice.error({
          title: '请输入域名',
          desc: '请输入完整的域名'
        })
        return
      }
      this.origin.domainList.push(this.pendingAddDomain)
      this.pendingAddDomain = ''
    },
    deleteDomain (domain) {
      for (let i = 0; i < this.origin.domainList.length; i++) {
        if (this.origin.domainList[i] === domain) {
          this.origin.domainList.splice(i, 1)
        }
      }
    },
    getOrigin () {
    },
    saveOrigin () {
    }
  }
}
</script>

<style scoped>

</style>
