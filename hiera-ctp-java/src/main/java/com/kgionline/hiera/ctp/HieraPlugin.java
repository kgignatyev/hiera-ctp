package com.kgionline.hiera.ctp;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.net.URL;
import java.util.Arrays;
import java.util.Base64;
import java.util.Collections;
import java.util.stream.Collectors;

public class HieraPlugin {

    static  ObjectMapper om = new ObjectMapper();

    public static class Result {
        String res;
        int returnCode;

        public Result(String res, int errorCode) {
            this.res = res;
            this.returnCode = errorCode;
        }

        public boolean hasError(){
            return returnCode != 200;
        }

    }


    public static Result get_key_value(String path) {
        try {
            var tree = om.readTree(new URL("http://localhost:8500/v1/kv/"+ path));
            var b64v = tree.get(0).get("Value").asText();
            String val = new String( Base64.getDecoder().decode(b64v));
            return new Result(val,200);
        } catch (IOException e) {
//            e.printStackTrace();
        }
        return new Result("42",-1);
    }


    public static Result find_key_value(String key, String[] path_parts)  {
        var parts = Arrays.asList( path_parts);
        Collections.reverse(parts);
        String res = null;

        for (int x=0; x< parts.size(); x++) {
            if (res == null) {
                StringBuilder sb = new StringBuilder();
                for( int i = 0; i <parts.size()-x;i++){
                    if( sb.length()!=0){
                        sb.append("/");
                    }
                    sb.append( parts.get(i));
                }
                sb.append("/").append(key);
                String path = sb.toString();
                var r = get_key_value(path);
                if( !r.hasError() ){
                    res = r.res;
                }
            }
        }
        return new Result(res,200);
    }


    public static void main(String[] args) {

        var path = Arrays.copyOfRange( args, 1, args.length);
        var r = find_key_value( args[0], path);

        var p = Arrays.asList(args).stream().collect(Collectors.joining( "," ) );
        System.out.println( "for " + p +" we got "+ r.res );
    }
}
