package main

import (
	"bufio"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"os"
	"os/exec"
)

func main() {
	r := gin.Default()
	r.StaticFS("/root", http.Dir("/root/"))
	r.GET("/d", func(c *gin.Context) {
		uu := c.Query("url")

		go func(u string) {
			fmt.Println(u + " start!!!!")
			download(u)
			fmt.Println(u + " done!!!!")
		}(uu)

		c.JSON(200, gin.H{
			"out": "ok",
		})
	})

	port := os.Getenv("PORT")
	if len(port) == 0 {
		port = "8080"
	}
	r.Run(":" + port)
}

func download(u string) {
	cc := "/root/run.sh " + u
	cmd := exec.Command("sh", "-c", cc)
	stderr, _ := cmd.StderrPipe()
	cmd.Start()

	scanner := bufio.NewScanner(stderr)
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		m := scanner.Text()
		fmt.Println(m)
	}
	cmd.Wait()
}
