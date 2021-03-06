const apiServer = process.env.VUE_APP_RIVER_API_URL;
const appServer = process.env.VUE_APP_RIVER_APP_URL;

const removeItem = () => {
  window.localStorage.removeItem("uid");
  window.localStorage.removeItem("access-token");
  window.localStorage.removeItem("client");
  window.localStorage.removeItem("nickname");
};

const setItem = (res) => {
  window.localStorage.setItem("access-token", res.headers["access-token"]);
  window.localStorage.setItem("client", res.headers.client);
  window.localStorage.setItem("uid", res.headers.uid);
  window.localStorage.setItem("nickname", res.data.data.nickname);
};

const getItem = () => {
  const uid = window.localStorage.getItem("uid");
  const client = window.localStorage.getItem("client");
  const accessToken = window.localStorage.getItem("access-token");
  const nickname = window.localStorage.getItem("nickname");
  return {
    uid: uid,
    client: client,
    accessToken: accessToken,
    nickname: nickname,
  };
};

const axiosHeaders = () => {
  const { uid, client, accessToken } = getItem();
  return {
    uid: uid,
    client: client,
    "access-token": accessToken,
  };
};

export { setItem, removeItem, getItem, apiServer, appServer, axiosHeaders };
