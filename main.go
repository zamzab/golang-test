package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"

	"firebase.google.com/go/auth"
	"github.com/gin-contrib/multitemplate"

	"cloud.google.com/go/firestore"

	"context"

	"github.com/gin-gonic/gin"

	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
)

func createMyRender() multitemplate.Renderer {
	r := multitemplate.NewRenderer()
	tplDir := "assets/tpl/"
	r.AddFromFiles("index", tplDir+"base.tpl", tplDir+"header.tpl", tplDir+"footer.tpl", tplDir+"main-index.tpl")
	r.AddFromFiles("signup", tplDir+"base.tpl", tplDir+"header.tpl", tplDir+"footer.tpl", tplDir+"main-signup.tpl")
	r.AddFromFiles("signin", tplDir+"base.tpl", tplDir+"header.tpl", tplDir+"footer.tpl", tplDir+"main-signin.tpl")
	r.AddFromFiles("private", tplDir+"base.tpl", tplDir+"header.tpl", tplDir+"footer.tpl", tplDir+"main-private.tpl")
	r.AddFromFiles("profiles", tplDir+"base.tpl", tplDir+"header.tpl", tplDir+"footer.tpl", tplDir+"main-profiles.tpl")
	return r
}

func main() {
	router := gin.Default()
	router.Static("/assets/css", "./assets/css")
	router.Static("/assets/images", "./assets/images")
	router.Static("/assets/js", "./assets/js")
	router.HTMLRender = createMyRender()
	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index", nil)
	})
	router.GET("/index.html", func(c *gin.Context) {
		c.Redirect(http.StatusMovedPermanently, "/")
	})
	router.GET("/signup", func(c *gin.Context) {
		c.HTML(http.StatusOK, "signup", nil)
	})
	router.GET("/signin", func(c *gin.Context) {
		c.HTML(http.StatusOK, "signin", nil)
	})
	router.GET("/private", func(c *gin.Context) {
		c.HTML(http.StatusOK, "private", nil)
	})
	router.GET("/profiles", func(c *gin.Context) {
		c.HTML(http.StatusOK, "profiles", nil)
	})
	privateGroup := router.Group("/", AuthMiddleware())
	{
		privateGroup.GET("/auth", func(c *gin.Context) {
			log.Print("Verified ID token\n")
			c.JSON(http.StatusOK, nil)
		})
		privateGroup.GET("/getboard", func(c *gin.Context) {
			log.Print("Verified ID token\n")
			uid, _ := c.Get("uid")
			app := initFirebaseApp()
			client := initFirestoreClient(app)
			defer client.Close()
			b, err := client.Collection("users").Doc(uid.(string)).Get(c)
			if err != nil {
				c.JSON(http.StatusNoContent, gin.H{"contents": false})
			} else {
				data := b.Data()
				c.JSON(http.StatusOK, gin.H{"contents": data["board"]})
			}
		})
		privateGroup.POST("/addboard", func(c *gin.Context) {
			log.Print("Verified ID token\n")
			buf, _ := ioutil.ReadAll(c.Request.Body)
			b := string(buf)
			uid, _ := c.Get("uid")
			app := initFirebaseApp()
			client := initFirestoreClient(app)
			defer client.Close()
			_, err := client.Collection("users").Doc(uid.(string)).Set(c, map[string]interface{}{
				"board": b,
			})
			if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"contents": false})
			} else {
				c.JSON(http.StatusOK, gin.H{"contents": "data add done!"})
			}
		})
	}
	// corsGroup := router.Group("/assets/js/", CORSMiddleware())
	// {
	// 	corsGroup.GET("common.js", func(c *gin.Context) {
	// 		c.JSON(http.StatusOK, nil)
	// 	})
	// }
	router.Run("localhost:8080")
}

// Opt GoogleAuthKey
var Opt = option.WithCredentialsFile("writers-cloud-firebase-adminsdk-963qc-90f79109c4.json")

func initFirebaseApp() *firebase.App {
	app, err := firebase.NewApp(context.Background(), nil, Opt)
	if err != nil {
		fmt.Printf("error: %v\n", err)
	}
	return app
}
func initAuth(app *firebase.App) *auth.Client {
	auth, err := app.Auth(context.Background())
	if err != nil {
		fmt.Printf("error: %v\n", err)
	}
	return auth
}
func initFirestoreClient(app *firebase.App) *firestore.Client {
	client, err := app.Firestore(context.Background())
	if err != nil {
		fmt.Printf("error: %v\n", err)
	}
	// defer client.Close()
	return client
}

// AuthMiddleware private環境アクセス時のjwtチェック
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		app := initFirebaseApp()
		auth := initAuth(app)
		authHeader := c.Request.Header.Get("Authorization")
		idToken := strings.Replace(authHeader, "Bearer ", "", 1)
		token, err := auth.VerifyIDToken(context.Background(), idToken)
		if err != nil {
			c.Status(http.StatusUnauthorized)
			c.Abort()
		} else {
			c.Set("uid", token.UID)
			c.Next()
		}
	}
}

// func CORSMiddleware() gin.HandlerFunc {
// 	return func(c *gin.Context) {
// 		host := c.Request.Host
// 		protocol := "https"
// 		if strings.HasPrefix(host, "localhost") {
// 			protocol = "http"
// 		}
// 		origin := protocol + "://" + host
// 		c.Writer.Header().Set("Access-Control-Allow-Origin", origin)
// 		c.Writer.Header().Set("AMP-Access-Control-Allow-Source-Origin", origin)
// 		c.Writer.Header().Set("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
// 		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS, HEAD, PUT")
// 		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
// 		if c.Request.Method == "OPTIONS" {
// 			c.AbortWithStatus(200)
// 		} else {
// 			c.Next()
// 		}
// 	}
// }
