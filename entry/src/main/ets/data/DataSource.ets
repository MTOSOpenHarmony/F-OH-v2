/*
 * Copyright (C) 2023 westinyang https://gitee.com/ohos-dev
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import { HomePageData } from '../model/HomePageData';
import {AppInfo, AppType} from '../model/AppInfo';
import http from '@ohos.net.http';
import deviceInfo from '@ohos.deviceInfo'
import fileio from '@ohos.fileio';
import util from '@ohos.util';

// 服务器地址
// 本地调试请拉取F-OH-Data仓库到本地，并启动一个静态资源服务器，使用本地服务器，尽量避免使用线上服务器地址
// const ds_server: string = "http://192.168.1.100:8080";
const ds_server: string = "http://192.168.0.108:8889/";
const currentAPI: number = deviceInfo.sdkApiVersion;
const arch: string = deviceInfo.abiList
const devTyp: string = deviceInfo.deviceType
// API Path
const api_homePageData: string = ds_server + "/homePageData.json";
const api_allAppList: string = ds_server + "/allAppList.json";
const api_fetchinfo: string = ds_server + "/fetchinfo/";
var appname = 'AppMarket'
class DataSource {
  public static allAppList: AppInfo[] = [];
  public static permissions: {"ohosperm":{}};
  constructor() {
  }
  static load(){
    globalThis.getContext().resourceManager.getRawFd('permissions.json',(error, value)=>{
      let fd = value.fd;
      let buf = new ArrayBuffer(value.length);
      fileio.read(fd, buf, function (err, readOut) {
        if (readOut) {

          DataSource.permissions = JSON.parse(new util.TextDecoder().decodeWithStream(new Uint8Array(readOut.buffer)))
          //console.info(this.permissions["ohos.permission.USE_BLUETOOTH"])
        }
      });
    })
    return this.permissions
  }
  /**
   * 获取首页数据
   */
  static getHomePageData(success: Function, error: Function) {
    let httpRequest = http.createHttp();
    this.load()
    httpRequest.request(api_homePageData, {
      method: http.RequestMethod.GET
    }, (err, data) => {
      if (!err && data.responseCode == 200) {
        let dataJson = JSON.parse(data.result as string) as Object
        let dataObj = new HomePageData(dataJson)
        appname = dataObj.appName
        for (var data2 in dataObj.sections as []){
          var data3 = dataObj.sections[data2]
          let tmpList: AppInfo[] = [];
            data3.apps.map((item)=>{
              tmpList.push(new AppInfo(item))
          })
          data3.apps = tmpList
        }
        success(dataObj);
      } else {
        console.info('error:' + err);
        httpRequest.destroy();
        error(err);
      }
    });
  }

  /**
   * 获取应用列表数据
   */
  static getAppList(appType: AppType, success: Function) {
    let httpRequest = http.createHttp();
    httpRequest.request(api_allAppList, {
      method: http.RequestMethod.GET
    }, (err, data) => {
      if (!err && data.responseCode == 200) {
        // JSON字符串 转 数组（这里直接 as AppInfo[] 会导致元数据之外的属性不存在）
        let dataArr = JSON.parse(data.result as string) as []
        // 数组 转 数组对象
        let tmpList: AppInfo[] = [];
        dataArr.map((item)=>{
          tmpList.push(new AppInfo(item))
        })
        DataSource.allAppList = tmpList;
        // 过滤类型
        let filterData: AppInfo[] = DataSource.allAppList
        success(filterData, dataArr.length);
      } else {
        console.info('error:' + JSON.stringify(err));
        httpRequest.destroy();
      }
    });
  }


}

export {DataSource, ds_server,currentAPI,arch,devTyp,api_fetchinfo,appname}