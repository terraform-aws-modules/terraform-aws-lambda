package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
	Name string `json:"name"`
}

func HandleRequest(ctx context.Context, event *MyEvent) (*string, error) {
	if event == nil {
		return nil, fmt.Errorf("received nil event")
	}
	message := fmt.Sprintf("Hello %s! serverless.tf was here!", event.Name)
	return &message, nil
}

func main() {
	lambda.Start(HandleRequest)
}
