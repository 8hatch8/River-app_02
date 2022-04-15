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

export { setItem, removeItem };
