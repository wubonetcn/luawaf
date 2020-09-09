<template>
  <div>
    <Card>
      <p slot="title">缓存</p>
      <Form :model="cache" :label-width="100">
        <FormItem label="静态文件缓存">
          <i-switch v-model="cache.open" size="large">
            <span slot="open">On</span>
            <span slot="close">Off</span>
          </i-switch>
        </FormItem>
        <FormItem>
          <Button type="primary" @click="saveCache">保存</Button>
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
      cache: {
        open: false
      }
    }
  },
  methods: {
    getCache () {
    },
    saveCache () {
    }
  }
}
</script>

<style scoped>

</style>
