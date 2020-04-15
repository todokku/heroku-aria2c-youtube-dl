package main

import (
	"bufio"
	"fmt"
	"github.com/gin-gonic/gin"
	"os"
	"os/exec"
)

func main() {
	r := gin.Default()
	r.GET("/d", func(c *gin.Context) {

		fmt.Println(c.Query("url"))

		cc := "/root/run.sh " + c.Query("url")
		cmd := exec.Command("sh", "-c", cc)
		stderr, _ := cmd.StderrPipe()
		cmd.Start()

		var rs []string
		scanner := bufio.NewScanner(stderr)
		scanner.Split(bufio.ScanWords)
		for scanner.Scan() {
			m := scanner.Text()
			fmt.Println(m)
			rs = append(rs, m)
		}
		cmd.Wait()

		c.JSON(200, gin.H{
			"out": rs,
		})
	})

	port := os.Getenv("PORT")
	if len(port) == 0 {
		port = "8080"
	}
	r.Run(":" + port)
}
