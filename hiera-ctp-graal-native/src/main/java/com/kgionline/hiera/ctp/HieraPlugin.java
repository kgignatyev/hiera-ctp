package com.kgionline.hiera.ctp;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.net.URL;
import java.util.Arrays;
import java.util.Base64;
import java.util.Collections;
import java.util.List;

import static java.util.Arrays.copyOfRange;

public class HieraPlugin {

    static ObjectMapper om = new ObjectMapper();

    public static class Result {
        String res;
        int responseCode;

        public Result(String res, int responseCode) {
            this.res = res;
            this.responseCode = responseCode;
        }

        public boolean hasError() {
            return responseCode != 200;
        }

    }
    


    public static Result get_key_value(String path) {
        try { //works faster than testing for return code before attempting to parse
            JsonNode tree = om.readTree(new URL("http://localhost:8500/v1/kv/" + path));
            String  b64v = tree.get(0).get("Value").asText();
            String val = new String(Base64.getDecoder().decode(b64v));
            return new Result(val, 200);
        } catch (IOException e) {
            //e.printStackTrace();
        }
        return new Result("42", -1);
    }

    public static String get_key_value_or_null(String path) {
        Result r = get_key_value(path);
        return r.hasError() ? null : r.res;
    }

    public static Result find_key_value(String key, String[] path_parts) {
        List<String> parts = Arrays.asList(path_parts);
        Collections.reverse(parts);
        String res = null;
        for (int x = 0; x < parts.size(); x++) {
            if (res == null) {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < parts.size() - x; i++) {
                    if (sb.length() != 0) {
                        sb.append("/");
                    }
                    sb.append(parts.get(i));
                }
                sb.append("/").append(key);
                String path = sb.toString();
                res = get_key_value_or_null(path);
            }
        }
        if (res == null) { // lets try to find a default
            res = get_key_value_or_null("default/" + key);
        }
        return new Result(res, 200);
    }


    public static void main(String[] args) {
        String[] path = copyOfRange(args, 1, args.length);
        Result r = find_key_value(args[0], path);
        String p = String.join(",", args);
        System.out.println(r.res);
    }
}
