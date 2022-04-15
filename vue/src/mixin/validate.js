import axios from "axios";
import { removeItem } from "./auth";
import { ref } from "vue";
const error = ref(null);

const validate = async () => {
  error.value = null;

  const uid = window.localStorage.getItem("uid");
  const client = window.localStorage.getItem("client");
  const accessToken = window.localStorage.getItem("access-token");

  try {
    const response = await axios.get("http://localhost:3000/auth/validate_token", {
      headers: {
        uid: uid,
        "access-token": accessToken,
        client: client,
      },
    });
    if (!response) {
      throw new Error("認証に失敗しました");
    }
    return response;
  } catch (error) {
    error.value = "認証に失敗しました";
    removeItem();
  }
};

const useValidate = () => {
  return { error, validate };
};

export default useValidate;
