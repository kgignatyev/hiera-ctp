package main

import (
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
)

type KeyData struct {
  Key string
  Value string
}

func reverse(parts []string) []string {
	arrayLen := len(parts)
	reversed := make([]string, arrayLen)
	for i, j := 0, arrayLen-1; i < arrayLen; i,j = i+1, j-1 {
		reversed[i] = parts[j]
	}
	return reversed
}


func get_key_value(key string, path []string) (string, error) {
	prefixPath := strings.Join( reverse(path), "/")
	resp, err := http.Get("http://localhost:8500/v1/kv/"+ prefixPath + "/" + key)
	var js []KeyData
	if err == nil {
		defer resp.Body.Close()
		if resp.StatusCode == http.StatusOK {
			bodyBytes, err := ioutil.ReadAll(resp.Body)
			if err == nil {
				unmarshalErr := json.Unmarshal(bodyBytes, &js)
				if unmarshalErr != nil {
					return "", unmarshalErr
				}
				decoded, err := base64.StdEncoding.DecodeString(js[0].Value)
				return string(decoded), err
			}else{ return "", err }
		}else{
			return "", errors.New( fmt.Sprintf("status code was %v ", resp.StatusCode))
		}
	}
	return "", err
}
func find_key_value(key string, path []string) (string,error) {
	idx := 0
	var v = ""
	var err error
	for idx < len(path){
		p := path[idx:]
		v,err =get_key_value( key, p)
		if err == nil {
			return v,nil
		}
		idx = idx+1
	}
	return v, errors.New("not found")
}
func main() {
	key,path := os.Args[1],os.Args[2:]
	v,err:=find_key_value(key,path)
	if err!= nil {
		v,err = find_key_value(key, []string{"default"})
	}
	if err !=nil {
		v = "null"
	}
	fmt.Println(v)
	//println(v)    //prints to stdERROR
}
