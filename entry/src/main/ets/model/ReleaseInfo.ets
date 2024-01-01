import { ds_server } from '../data/DataSource';

class ReleaseInfo {
  constructor(source: Partial<ReleaseInfo>) {
    Object.assign(this, source);
  }
  id: number;
  version: string;
  hapUrl: string;
  releaseTime: string;
  minimumAPI: number;
  minimumOldVersion: number;
  downloadLatestIfNew: number;
  deviceType: string;  // P=Phone, T=Tablet
  archType: number;  // 1=arm64, 2=arm, 3=x86, 4=x86_64
  changeLog: string;
  requiredPerm: string[];
  verCode: number;
  getHapUrl() {
    return this.hapUrl ? ds_server + this.hapUrl : this.hapUrl;
  }
}
export {ReleaseInfo}