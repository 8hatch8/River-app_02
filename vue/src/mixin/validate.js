import axios from "axios";
import { removeItem, axiosHeaders, apiServer } from "@/mixin/auth";
import { ref } from "vue";
const error = ref(null);

const validate = async () => {
  error.value = null;

  try {
    const response = await axios.get(`${apiServer}/auth/validate_token`, {
      headers: axiosHeaders(),
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
