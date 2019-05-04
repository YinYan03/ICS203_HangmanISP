% Ryan Phan
% June 8, 2018
% Mr. Rosen
% This program outputs an hangman game

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Screen Setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import GUI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Declaration Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var mainWin := Window.Open ("position:300;300,graphics:640;400") % The main window of the program
var level, incorrect, hintLetter : int := 0
var answer, usedLetters, correct : string := ""
var mouseX, mouseY, button : int := 0 % Finds where the mouse is and sees if it clicks.
var gallowsPic : int := 0 % Draws the gallows and the person being hung.
var exitButton, lvl1Button, lvl2Button, mainMenuButton, instructButton : int := 0 % All the GUI buttons in the game.
var win : boolean := false    % Tells the program if the user wins or not
var words : array 1 .. 11 of string := init ("mouse", "monitor", "motherboard", "memory", "storage", "gigabyte", "peripheral", "software", "malware", "volatile", "hardware")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Forward Procedures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
forward proc mainMenu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Procedures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plays some background music
process music
    Music.PlayFileLoop ("ThemeSong.mp3")
end music

% The title procedure. It clears the screen for the game.
procedure title
    var titleFont := Font.New ("Comic Sans MS:16:bold")
    cls
    Font.Draw ("Hangman", 260, 370, titleFont, black)
end title

% The instructions procedure - tells the user what to do.
procedure instruct
    var instructFont := Font.New ("Comic Sans MS:12")
    GUI.Hide (instructButton)
    GUI.Hide (lvl1Button)
    GUI.Hide (lvl2Button)
    GUI.Hide (exitButton)
    title
    Font.Draw ("Instructions:", 260, 340, instructFont, black)
    Font.Draw ("1. Guess the word in the blank (It is randomly chosen from 11 computer terms)", 10, 310, instructFont, black)
    Font.Draw ("2. You can choose what letters you want from the bottom.", 10, 290, instructFont, black)
    Font.Draw ("3. You lose when the person in fully drawn. You have 9 tries!", 10, 270, instructFont, black)
    Font.Draw ("4. There are 2 levels to choose from. Level 1 has a hint while level 2 does not.", 10, 250, instructFont, black)
    Font.Draw ("5. Have Fun!", 10, 230, instructFont, black)
    GUI.Show (mainMenuButton)
end instruct

% Selects a random word for the user to guess from the "words" array
procedure randWord
    var random : int
    randint (random, 1, 11)
    answer := words (random) % Sets answer to a random word 
end randWord

% Displays the user's results
procedure display
    title                                              % Clears the screen
    var displayFont := Font.New ("Comic Sans MS:15")   % Font used in display
    GUI.Show (mainMenuButton)                          % Allows the user to return to main menu

    % Checks if the user wins or not
    if incorrect = 9 then
	Font.Draw ("You Died!!!", 260, 300, displayFont, black)
	Font.Draw ("The word was:", 240, 260, displayFont, blue)
	Font.Draw (answer, 263, 225, displayFont, red)
	Music.PlayFile ("Loss.mp3")
    elsif win = true then
	Font.Draw ("You guessed the word!!!", 200, 300, displayFont, black)
	Font.Draw ("The word was:", 240, 260, displayFont, blue)
	Font.Draw (answer, 265, 225, displayFont, red)
	Music.PlayFile ("TaDa.mp3")
    end if

    % Resets everything
    level := 0
    correct := ""
    usedLetters := ""
    incorrect := 0
    win := false
    hintLetter := 0
end display

% The bulk of the game, this procedure displays the game screen
procedure userInput
    % Clears the screen
    title

    % Declaration of local variables
    var levelFont := Font.New ("Comic Sans MS:14")
    var guess : string (1) := ""

    % Hides all main menu buttons
    GUI.Hide (exitButton)
    GUI.Hide (lvl1Button)
    GUI.Hide (lvl2Button)
    GUI.Hide (instructButton)

    gallowsPic := Pic.FileNew ("Hangman.jpg") % Draws the gallows
    Pic.Draw (gallowsPic, 0, 80, picMerge)

    % If the user wants to return to the main menu they can click here
    locate (2, 62)
    put "Back to Main Menu"
    drawbox (485, 368, 625, 383, red)

    % Selects a random word and puts the dashes
    randWord
    locate (12, 40)
    var dashes : array 1 .. length (answer) of string  % Dashes array, determines how many dashes to put
    for x : 1 .. length (answer)
	dashes (x) := "_"
	put dashes (x) : 3 ..
    end for

    % Draws the keyboard
    for x : 0 .. 12
	% First Row Of Letters
	drawbox (5 + 50 * x, 45, 35 + 50 * x, 75, black)
	Font.Draw (chr (65 + x), 12 + 50 * x, 53, Font.New ("Comic Sans MS:15"), blue)
	% Second Row Of Letters
	drawbox (5 + 50 * x, 10, 35 + 50 * x, 40, black)
	Font.Draw (chr (78 + x), 12 + 50 * x, 18, Font.New ("Comic Sans MS:15"), blue)
    end for

    if level = 1 then
	locate (12, 40)
	% Gives the hint, which is the first letter of the word
	for x : 1 .. length (answer)
	    if answer (1) = answer (x) then     % Checks how many times the first letter appears in the answer
		dashes (x) := answer (1)        % Changes the dashes to the hint given letter
		hintLetter += 1                 % The amount of letters given in the hint
	    end if
	    put dashes (x) : 3 ..
	end for

	% Removes the letter that the hint gives you from the keyboard
	for x : 0 .. 12
	    if answer (1) = chr (97 + x) then                         % If the hint is equal to any of the letters in the first row then
		drawfillbox (5 + 50 * x, 45, 35 + 50 * x, 75, white)  % Hides the hint letter
	    elsif answer (1) = chr (110 + x) then                     % Likewise, if hint is equal to any of the second row letters then
		drawfillbox (5 + 50 * x, 10, 35 + 50 * x, 40, white)  % Hides the hint letter
	    end if
	end for

	% Tells the user what level they're on
	Font.Draw ("Level 1", 270, 335, levelFont, black)
    else
	Font.Draw ("Level 2", 270, 335, levelFont, black)
    end if

    loop
	% Mouse Touch Targets
	mousewhere (mouseX, mouseY, button)
	if button = 1 then      % Finds if the user clicks the mouse
	    for x : 0 .. 12
		if (mouseX >= 5 + 50 * x and mouseX <= 35 + 50 * x) and (mouseY >= 45 and mouseY <= 75) then     % Checks if the user presses anywhere in the first row
		    guess := chr (97 + x)                                                                        % Sets the guess values from "a" to "m".
		    drawfillbox (5 + 50 * x, 45, 35 + 50 * x, 75, white)                                         % Erases whatever letter the user presses
		elsif (mouseX >= 5 + 50 * x and mouseX <= 35 + 50 * x) and (mouseY >= 10 and mouseY <= 40) then  % Checks if the user presses anywhere in the first row
		    guess := chr (110 + x)                                                                       % Sets up the guess values from "n" to "z"
		    drawfillbox (5 + 50 * x, 10, 35 + 50 * x, 40, white)                                         % Erases whatever letter the user presses
		end if
	    end for

	    % Prevents the user from guessing the same letter twice
	    if index (usedLetters, (guess)) = 0 then  % Checks usedLetters for guess
		usedLetters += guess                  % If the index returns 0 then add guess to usedLetters
	    else
		guess := ""                           % If the index returns a value higher than 0 then guess will return no value
	    end if

	    % Prevents  the user from guessing the same letter the hint gives them
	    if level = 1 and guess = answer (1) then
		guess := ""
	    end if

	    % If the answer is wrong then add another body part
	    if index (answer, (guess)) = 0 then
		incorrect += 1                        % Adds one to incorrect, allowing the program to tell what to draw
		guess := ""
	    end if

	    if incorrect = 1 then
		gallowsPic := Pic.FileNew ("Hangman1.jpg")     % Draws the head
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    elsif incorrect = 2 then
		gallowsPic := Pic.FileNew ("Hangman2.jpg")     % Draws the body
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    elsif incorrect = 3 then
		gallowsPic := Pic.FileNew ("Hangman3.jpg")     % Draws the left arm
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    elsif incorrect = 4 then
		gallowsPic := Pic.FileNew ("Hangman4.jpg")     % Draws the right leg
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    elsif incorrect = 5 then
		gallowsPic := Pic.FileNew ("Hangman5.jpg")     % Draws the left arm
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    elsif incorrect = 6 then
		gallowsPic := Pic.FileNew ("Hangman6.jpg")     % Draws the right arm
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    elsif incorrect = 7 then
		gallowsPic := Pic.FileNew ("Hangman7.jpg")     % Draws the left eye
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    elsif incorrect = 8 then
		gallowsPic := Pic.FileNew ("Hangman8.jpg")     % Draws the right eye
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    elsif incorrect = 9 then
		gallowsPic := Pic.FileNew ("Hangman9.jpg")     % Draws the mouth, finishing the body
		Pic.Draw (gallowsPic, 0, 80, picMerge)
	    end if

	    % Checks if the letter chosen was correct
	    locate (12, 40)
	    for x : 1 .. length (answer)
		if guess = answer (x) then   % If guess is equal to any of the letters in answer then
		    dashes (x) := guess      % Change the dash to the letter
		    correct += guess         % Add that letter to correct
		end if
		put dashes (x) : 3 ..        % Put the letter in the blank
	    end for

	    % Displays if the word was correct or not
	    if length (correct) = length (answer) then   % If correct letters is as long as answer then
		win := true                              % Win condition will be true
	    elsif level = 1 and length (correct) + hintLetter = length (answer) then % If correct letters and hint-given letters add up then
		win := true                                                          % Win condition will be true
	    end if
	    exit when (mouseX >= 485 and mouseX <= 625) and (mouseY >= 368 and mouseY <= 383) % Checks if the user presses on the main menu button
	end if
	delay (50)
	guess := ""                     % Resets guess
	exit when incorrect = 9 or win  % Exit the loop when the user wins or loses
    end loop

    if (mouseX >= 485 and mouseX <= 625) and (mouseY >= 368 and mouseY <= 383) then % Checks if the user exited the loop by pressing on main menu
	% Reset Everything and return to main menu
	level := 0
	correct := ""
	usedLetters := ""
	incorrect := 0
	win := false
	hintLetter := 0
	mainMenu
    else
	delay (500)
	display % Display the user's results
    end if
end userInput

% Sets the level to 1, so the program can add a hint in userInput
procedure hint
    level := 1
    userInput
end hint

% Main Menu
body procedure mainMenu
    Window.Show (mainWin)
    GUI.Hide (mainMenuButton)
    title
    instructButton := GUI.CreateButton (260, 250, 0, "Instructions", instruct)  % Goes to the instructions window
    lvl1Button := GUI.CreateButton (270, 200, 0, "Level 1", hint)               % Goes to hint, which sets the level to 1
    lvl2Button := GUI.CreateButton (270, 150, 0, "Level 2", userInput)          % Goes straight to userInput
    exitButton := GUI.CreateButton (277, 100, 0, "Exit", GUI.Quit)              % Goes to goodbye, then stops the game
end mainMenu

% The goodbye procedure. Exits the game.
procedure goodbye
    var goodbyeFont := Font.New ("Comic Sans MS:13")
    title
    Font.Draw ("Thanks for trying my game!", 205, 240, goodbyeFont, black)
    Font.Draw ("Program Written By:", 230, 210, goodbyeFont, black)
    Font.Draw ("Ryan Phan", 265, 180, goodbyeFont, black)
    delay (1000)
    Music.PlayFileStop     % Stops the music
    Window.Close (mainWin) % Closes the game
end goodbye

% The introduction screen
procedure intro
    fork music    % Starts the music
    var introFont := Font.New ("Comic Sans MS:20:bold,italic")

    % Draws the background
    for x : 1 .. 640
	drawline (0 + x, 0, 0 + x, 400, 28)
    end for

    % Draws the title coming in from the top
    for x : 1 .. 100
	drawfillbox (225, 395 - x, 425, 460 - x, 28)   % Erase
	Font.Draw ("Ryan's", 275, 435 - x, introFont, blue)
	Font.Draw ("Hangman Game", 225, 400 - x, introFont, red)
	delay (10)
    end for

    % Draws The Gallows Sliding In
    for x : 1 .. 500
	drawfillbox (-261 + x, 276, -100 + x, 160, 28) % Erase
	drawline (-260 + x, 160, -100 + x, 160, black) % Platform
	drawline (-220 + x, 160, -220 + x, 275, black) % Post
	drawline (-220 + x, 275, -160 + x, 275, black) % Top beam
	drawline (-160 + x, 275, -160 + x, 260, black) % Rope Support
	drawline (-220 + x, 260, -200 + x, 275, black) % Top Support
	drawline (-220 + x, 180, -200 + x, 160, black) % Bottom Support
	delay (4)
    end for

    % Main Menu Button
    mainMenuButton := GUI.CreateButton (265, 50, 0, "Main Menu", mainMenu)
end intro

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main Program %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intro
loop
    exit when GUI.ProcessEvent
end loop
goodbye
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of Main Program %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
