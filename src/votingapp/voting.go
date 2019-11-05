package main

import (
	"net/http"

	"github.com/labstack/echo"
)

var state = votingState{make(map[string]int), ""}

type votingState struct {
	Votes  map[string]int `json:"votes"`
	Winner string         `json:"winner"`
}

type votingOptions struct {
	Topics []string `json:"topics"`
}

type voteOption struct {
	Topic string `json:"topic"`
}

func getVotes(c echo.Context) error {
	return c.JSON(http.StatusOK, state)
}

func startVoting(c echo.Context) error {
	topics := new(votingOptions)
	if err := c.Bind(topics); err != nil {
		return err
	}

	for _, val := range topics.Topics {
		state.Votes[val] = 0
	}

	state.Winner = ""
	return saveAndPublishState(c)
}

func vote(c echo.Context) error {
	topic := new(voteOption)
	if err := c.Bind(&topic); err != nil {
		return err
	}

	if state.Winner != "" {
		return c.JSON(http.StatusBadRequest, state)
	}

	state.Votes[topic.Topic] = state.Votes[topic.Topic] + 1
	return saveAndPublishState(c)
}

func finishVoting(c echo.Context) error {
	winner := getRandomKey(state.Votes)
	for topic, count := range state.Votes {
		if count > state.Votes[winner] {
			winner = topic
		}
	}

	state.Winner = winner
	return saveAndPublishState(c)
}

func saveAndPublishState(c echo.Context) error {
	err := sendMessage(state)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, state)
}
