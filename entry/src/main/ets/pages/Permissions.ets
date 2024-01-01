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
struct AppDetail {
  @State mainAbilityName: string = '';
  @State releaseInfo: ReleaseInfo = new ReleaseInfo(router.getParams()['releaseInfo'])
  onPageShow() {
    console.info('AboutComponent onPageShow');
    WindowStageUtil.setLayoutFullScreen(globalThis.windowStage, '#ffffff', WindowStageUtil.COLOR_BLACK, '#ffffff', WindowStageUtil.COLOR_BLACK);
  }

  @Builder NavigationTitle() {
    Column() {
      Text('View Permissions')
        .fontColor('#182431')
        .fontSize(26)
        .fontWeight(500)
    }.alignItems(HorizontalAlign.Start)
    .width('100%')
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        // 页面标题
        Navigation()
          .title(this.NavigationTitle())
          .hideToolBar(true)
          .height(56)
          .backgroundColor("#f1f3f5")
          .width('100%')
          .titleMode(NavigationTitleMode.Mini)
          .hideBackButton(false)


        Column() {
          Text("After installing the application, you can manage these permissions in settings.").opacity(0.8)
          List(){
            ForEach(this.releaseInfo.requiredPerm,(item,index)=>{
              ListItem(){
                Text(this.releaseInfo.requiredPerm[index])
              }
              .height(80)
              .width("100%")
              .margin(10)
              .backgroundColor("white")
              .borderRadius(25)
            })
          }
          .height("90%")
        }
        .height("100%")
        .align(Alignment.Start)
        .backgroundColor("#f1f3f5")
        .width('100%')
        .margin({bottom: 56})

      }
      .width('100%')
      .height('100%')

    }.width('100%').height('100%')
  }
}


