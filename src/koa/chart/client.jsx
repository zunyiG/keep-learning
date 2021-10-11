import React, { useState, useEffect } from 'react';
import styles from './index.less';

export default () => {
  const [webSocket, setWebSocket] = useState(false)
  useEffect(() => {
    const CreateWebSocket = (function () {
      return function (urlValue) {
          if(window.WebSocket) return new WebSocket(urlValue);
          if(window.MozWebSocket) return new MozWebSocket(urlValue);
          return false;
      }
    })();
    /* 实例化 WebSocket 连接对象, 地址为 ws 协议 */
    const webSocket = CreateWebSocket("ws://db-vm.zy:9000");
    if(webSocket) {
      console.log('建立连接')
    }
    /* 接收到服务端的消息时 */
    webSocket.onmessage = function (msg) {
      console.log("服务端说:" + msg.data);
    };
    /* 关闭时 */
    webSocket.onclose = function () {
      console.log("关闭连接");
    };

    setWebSocket(webSocket)

    return () => {
      webSocket.close()
    }
  }, [])

  const [message, setMessage] = useState('')
  const onSend = function () {
    webSocket && webSocket.send(message);
  }
  const onClose = function () {
    webSocket && webSocket.close();
}
  return (
    <div>
      <input value={message} onChange={(e) => setMessage(e.target.value)} type="text"/>
      <input type="button" value="发送" onClick={onSend} />
      <input type="button" value="关闭" onClick={onClose} />
    </div>
  );
}
