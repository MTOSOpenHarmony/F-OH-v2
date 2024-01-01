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

import router from '@ohos.router'
import { InfoRow } from '../components/InfoRow';
import WindowStageUtil from '../util/WindowStageUtil';
import fileUri from '@ohos.file.fileuri';
import promptAction from '@ohos.promptAction';
import fileio from '@ohos.fileio';
import installer from '@ohos.bundle.installer';
import hilog from '@ohos.hilog';
import bundleManager from '@ohos.bundle.bundleManager';
import fs from '@ohos.file.fs';
import {AppInfo, AppActionText, AppStatus} from '../model/AppInfo';
import request from '@ohos.request';
import http from '@ohos.net.http';
import { api_fetchinfo, arch, currentAPI, devTyp } from '../data/DataSource';
import { ReleaseInfo } from '../model/ReleaseInfo';

const ToastDuration = 1000
@Entry
@Component
struct AppImage {
  @State mainAbilityName: string = '';
  @State scts:any[]=router.getParams()['scts'];
  @State index:number=router.getParams()['index'];
  @State url:string=router.getParams()['url'];
  onPageShow() {
    console.info('AboutComponent onPageShow');
    WindowStageUtil.setLayoutFullScreen(globalThis.windowStage, '#ffffff', WindowStageUtil.COLOR_BLACK, '#ffffff', WindowStageUtil.COLOR_BLACK);
  }


  build() {

      Column() {
        // 页面标题
        Navigation()
          .hideToolBar(true)
          .height(56)
          .width('100%')
          .titleMode(NavigationTitleMode.Mini)
          .hideBackButton(false)
        Swiper(){
         ForEach(this.scts,(item,index)=>{
           Image(item)
             .objectFit(ImageFit.Contain)

         })

        }
        .index(this.index)
        .height('90%')
        .indicator(true)
        .onChange((index)=>{this.url = this.scts[index],this.index=index})
        .sharedTransition(this.url)

      }

      .width('100%')
      .height('100%')

  }
}


