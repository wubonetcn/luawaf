<template>
  <Layout style="height: 100%" class="main">
    <Sider hide-trigger collapsible :width="256" :collapsed-width="64" v-model="collapsed" class="left-sider"
           :style="{overflow: 'hidden'}">
      <side-menu accordion ref="sideMenu" :active-name="$route.name" :collapsed="collapsed" @on-select="turnToPage"
                 :menu-list="menuList">
        <!-- 需要放在菜单上面的内容，如Logo，写在side-menu标签内部，如下 -->
        <div class="logo-con">
          <img v-show="!collapsed" :src="maxLogo" key="max-logo"/>
          <img v-show="collapsed" :src="minLogo" key="min-logo"/>
        </div>
      </side-menu>
    </Sider>
    <Layout>
      <Header class="header-con">
        <header-bar :collapsed="collapsed" @on-coll-change="handleCollapsedChange">
          <user :user-name="'吴波'"/>
          <language v-if="$config.useI18n" @on-lang-change="setLocal" style="margin-right: 10px;" :lang="local"/>
          <error-store v-if="$config.plugin['error-store'] && $config.plugin['error-store'].showInHeader"
                       :has-read="hasReadErrorPage" :count="errorCount"></error-store>
          <fullscreen v-model="isFullscreen" style="margin-right: 10px;"/>
          <div class="header-v-center" style="margin-right: 5px">
            <Button @click="addOrigin">新增网站</Button>
          </div>
        </header-bar>
      </Header>
      <Content class="main-content-con">
        <Layout class="main-layout-con">
          <div class="tag-nav-wrapper">
            <tags-nav :value="$route" @input="handleClick" :list="tagNavList" @on-close="handleCloseTag"/>
          </div>
          <Content class="content-wrapper">
            <keep-alive :include="cacheList">
              <router-view/>
            </keep-alive>
            <ABackTop :height="100" :bottom="80" :right="50" container=".content-wrapper"></ABackTop>
          </Content>
          <Footer class="layout-footer-center">2020 &copy; LUAWAF</Footer>
        </Layout>
      </Content>
    </Layout>
    <Modal v-model="editOriginSwitch" title="新增网站" ok-text="保存" cancel-text="取消编辑"
           @on-ok="saveOrigin"
           :width="900">
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
      </Form>
    </Modal>
  </Layout>
</template>
<script>
import SideMenu from './components/side-menu'
import HeaderBar from './components/header-bar'
import TagsNav from './components/tags-nav'
import User from './components/user'
import ABackTop from './components/a-back-top'
import Fullscreen from './components/fullscreen'
import Language from './components/language'
import ErrorStore from './components/error-store'
import { mapMutations, mapActions, mapGetters } from 'vuex'
import { getNewTagList, routeEqual } from '@/libs/util'
import routers from '@/router/routers'
import minLogo from '@/assets/images/logo-mini.png'
import maxLogo from '@/assets/images/logo.jpg'
import './main.less'

export default {
  name: 'Main',
  components: {
    SideMenu,
    HeaderBar,
    Language,
    TagsNav,
    Fullscreen,
    ErrorStore,
    User,
    ABackTop
  },
  data () {
    return {
      collapsed: false,
      minLogo,
      maxLogo,
      isFullscreen: false,
      editOriginSwitch: false,
      pendingAddDomain: '',
      origin: {
        domainList: [],
        proxyPassUrl: '',
        websocket: false,
        useOtherCompanyCDNSwitch: false
      }
    }
  },
  computed: {
    ...mapGetters([
      'errorCount'
    ]),
    tagNavList () {
      return this.$store.state.app.tagNavList
    },
    tagRouter () {
      return this.$store.state.app.tagRouter
    },
    userAvator () {
      return this.$store.state.user.avatorImgPath
    },
    cacheList () {
      const list = ['ParentView', ...this.tagNavList.length ? this.tagNavList.filter(item => !(item.meta && item.meta.notCache)).map(item => item.name) : []]
      return list
    },
    menuList () {
      return this.$store.getters.menuList
    },
    local () {
      return this.$store.state.app.local
    },
    hasReadErrorPage () {
      return this.$store.state.app.hasReadErrorPage
    },
    unreadCount () {
      return this.$store.state.user.unreadCount
    }
  },
  methods: {
    addOrigin () {
      this.editOriginSwitch = true
    },
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
    },
    ...mapMutations([
      'setBreadCrumb',
      'setTagNavList',
      'addTag',
      'setLocal',
      'setHomeRoute',
      'closeTag'
    ]),
    ...mapActions([
      'handleLogin',
      'getUnreadMessageCount'
    ]),
    turnToPage (route) {
      let { name, params, query } = {}
      if (typeof route === 'string') name = route
      else {
        name = route.name
        params = route.params
        query = route.query
      }
      if (name.indexOf('isTurnByHref_') > -1) {
        window.open(name.split('_')[1])
        return
      }
      this.$router.push({
        name,
        params,
        query
      })
    },
    handleCollapsedChange (state) {
      this.collapsed = state
    },
    handleCloseTag (res, type, route) {
      if (type !== 'others') {
        if (type === 'all') {
          this.turnToPage(this.$config.homeName)
        } else {
          if (routeEqual(this.$route, route)) {
            this.closeTag(route)
          }
        }
      }
      this.setTagNavList(res)
    },
    handleClick (item) {
      this.turnToPage(item)
    }
  },
  watch: {
    '$route' (newRoute) {
      const { name, query, params, meta } = newRoute
      this.addTag({
        route: { name, query, params, meta },
        type: 'push'
      })
      this.setBreadCrumb(newRoute)
      this.setTagNavList(getNewTagList(this.tagNavList, newRoute))
      this.$refs.sideMenu.updateOpenName(newRoute.name)
    }
  },
  mounted () {
    /**
       * @description 初始化设置面包屑导航和标签导航
       */
    this.setTagNavList()
    this.setHomeRoute(routers)
    const { name, params, query, meta } = this.$route
    this.addTag({
      route: { name, params, query, meta }
    })
    this.setBreadCrumb(this.$route)
    // 设置初始语言
    this.setLocal(this.$i18n.locale)
    // 如果当前打开页面不在标签栏中，跳到homeName页
    if (!this.tagNavList.find(item => item.name === this.$route.name)) {
      this.$router.push({
        name: this.$config.homeName
      })
    }
    // 获取未读消息条数
    this.getUnreadMessageCount()
  }
}
</script>
<style>
  .header-v-center {
    display: inline-block;
    vertical-align: top;
  }

  .layout-footer-center {
    text-align: center;
    background: #ffffff!important;
  }
</style>
