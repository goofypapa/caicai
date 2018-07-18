//
//  BlueManager.swift
//  DadPat
//
//  Created by 吴思 on 5/2/18.
//  Copyright © 2018 吴思. All rights reserved.
//



import UIKit
import CoreBluetooth

class BlueManager : NSObject{
    
    private let Service_UUID: String = "FAA0"
    private let Characteristic_UUID: String = "FAA1"
    
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    
    
    override init()
    {
        super.init()
        print("test print")
        centralManager = CBCentralManager.init(delegate: self, queue: .main)
    }
    
    
    @IBAction func didClickGet(_ sender: Any) {
        self.peripheral?.readValue(for: self.characteristic!)
    }
    
    @IBAction func didClickPost(_ sender: Any) {
        
    }
    
}


extension BlueManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // 判断手机蓝牙状态
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("未知的")
        case .resetting:
            print("重置中")
        case .unsupported:
            print("不支持")
        case .unauthorized:
            print("未验证")
        case .poweredOff:
            print("未启动")
        case .poweredOn:
            print("可用")
//            central.scanForPeripherals(withServices: [CBUUID.init(string: Service_UUID)], options: nil)
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    /** 发现符合要求的外设 */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if(peripheral.name != nil)
        {
            
            print( "--------------", peripheral.name );
    //         根据外设名称来过滤
            if (peripheral.name?.hasPrefix("REMAX-019698"))! {
                
                if( self.peripheral != nil ){
                    return;
                }
                
                self.peripheral = peripheral
                print(peripheral.name!);
//                peripheral.setNotifyValue(true, for: CBCharacteristic)
                central.connect(peripheral, options: nil)
            }
            //central.connect(peripheral, options: nil)
        }
    }
    
    /** 连接成功 */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.centralManager?.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID.init(string: Service_UUID)])
        print("连接成功")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接失败")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("断开连接")
        // 重新连接
        central.connect(peripheral, options: nil)
    }
    
    /** 发现服务 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service: CBService in peripheral.services! {
            print("外设中的服务有：\(service)")
        }

        //本例的外设中只有一个服务
        let service = peripheral.services?.last
        
        if(service == nil){
            return;
        }
        // 根据UUID寻找服务中的特征
        peripheral.discoverCharacteristics([CBUUID.init(string: Characteristic_UUID)], for: service!)
    }
    
    /** 发现特征 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic: CBCharacteristic in service.characteristics! {
            print("外设中的特征有：\(characteristic)")
        }
        
        self.characteristic = service.characteristics?.last
        // 读取特征里的数据
        peripheral.readValue(for: self.characteristic!)
        // 订阅
        peripheral.setNotifyValue(true, for: self.characteristic!)
    }
    
    /** 订阅状态 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("订阅失败: \(error)")
            return
        }
        if characteristic.isNotifying {
            print("订阅成功")
        } else {
            print("取消订阅")
        }
    }
    
    /** 接收到数据 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data = characteristic.value
        if( data != nil )
        {
//            print("%d", data!.count)
            print( String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x", data![0], data![1], data![2], data![3], data![4], data![5], data![6], data![7], data![8] ) )
//            print(String.init(data: data!, encoding: String.Encoding.utf8)!)
        }
    }
    
    /** 写入数据 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("写入数据")
    }
}
