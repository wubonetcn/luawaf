import axios from 'axios'
import config from '@/config'

const baseUrl = process.env.NODE_ENV === 'development' ? config.baseUrl.dev : config.baseUrl.pro

const Axios = axios.create({
  baseURL: baseUrl
})
export default Axios
