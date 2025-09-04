This document outlines a complete set of requirements for building the Cal AI mobile application in Swift, based on a detailed analysis of the provided video recording. The instructions cover all pages, components, functionality, and design elements to ensure a high-fidelity replication.

1. Onboarding Flow
The onboarding flow is a multi-step process designed to gather user information and set up a personalized plan.

Page 1: Welcome Screen

Purpose: Introduce the app and prompt the user to start.

Components: A large, full-screen banner image showing a meal, centered text "Calorie tracking made easy," and a rounded, black "Get Started" button at the bottom.

Instructions: The "Get Started" button should be prominently placed with a rounded corner radius and white text.

Page 2: Gender Selection

Purpose: Collect gender information for plan calibration.

Components: A title "Choose your Gender," a subtitle "This will be used to calibrate your custom plan," and three vertically stacked, rounded buttons for "Male," "Female," and "Other."

Instructions: Unselected buttons are light gray; selected buttons are black with white text.

Page 3: Workout Frequency

Purpose: Determine physical activity level.

Components: Title "How many workouts do you do per week?", subtitle, and three selectable list items with a bullet point icon and text (e.g., "0-2 Workouts now and then").

Instructions: Similar to the gender selection, selected list items should have a black background and white text. The bullet point icon should fill in when selected.

Page 4: User Demographics (Multi-part)

Purpose: Gather essential personal data.

Components:

Source of Referral: A scrollable list of options (e.g., "Youtube," "Instagram").

Prior App Usage: Two buttons, "No" and "Yes," with thumbs-down/thumbs-up icons.

Height & Weight: A segmented control for Imperial/Metric units, with scrolling pickers for height (feet/inches) and weight (pounds).

Date of Birth: A date picker component for month, day, and year.

Instructions: Implement UIPickerView or a similar component for the scrolling date and measurement pickers.

Page 5: Goal Setting

Purpose: Define the user's primary objective and related parameters.

Components:

Goal Type: Three buttons for "Lose weight," "Maintain," and "Gain weight."

Desired Weight: A screen with a scrollable picker for the target weight.

Realistic Target: An interlude screen displaying a message like "Losing 12 lbs is a realistic target. It's not hard at all!"

Weight Loss Speed: A horizontal slider with icons (tortoise, rabbit, cheetah) at each end and a highlighted "Recommended" value.

Weight Comparison: A promotional interlude screen comparing "Without Cal AI" (20%) and "With Cal AI" (2X).

Instructions: The weight loss speed slider should dynamically update a text label with the current value.

Page 6: Obstacles & Preferences

Purpose: Understand user motivations and lifestyle.

Components:

Obstacles: A list of selectable options with icons (e.g., "Lack of consistency," "Unhealthy eating habits"). Multiple selections are allowed.

Diet Type: A list of selectable diet options.

Accomplishments: A list of selectable goals with icons (e.g., "Eat and live healthier").

Instructions: Ensure a clear visual state for both selected and unselected options.

Page 7: Plan Generation

Purpose: Visually represent the plan being created.

Components:

Weight Transition Chart: A screen with a chart that animates to show a weight loss curve.

Thank You Screen: An animated screen with "Thank you for trusting us" and a privacy message.

Apple Health Integration: A screen with an icon flow diagram connecting a running person, a heart, and a sleeping person to the Apple Health app. Tapping "Continue" should trigger the system's Health Access pop-up.

Calorie Adjustment Screens: Screens to "Add calories burned" and "Rollover extra calories."

Rating & Notifications: A screen prompting a 5-star rating with user reviews below, and a screen to request push notification permissions.

Referral Code: A screen with a text field for a referral code and a "Submit" button.

Loading Screen: A progress bar that animates from 0% to 100%, with a checklist of "Daily recommendation" items appearing as the bar fills.

Instructions: Use animations to create a dynamic, engaging feel for the plan generation process. The health access screen should trigger the native iOS system dialog for permission.

Page 8: Final Plan & Subscription

Purpose: Present the final plan and convert the user to a paying subscriber.

Components:

Final Plan Summary: A screen with a title "Congratulations your custom plan is ready!", the user's main goal, and a dashboard of four cards displaying daily "Calories," "Carbs," "Protein," and "Fats," along with a "Health Score" bar.

How to Reach Goals: A section listing actionable tips.

Sources: A list of academic sources at the bottom.

Sign-In: A screen with "Sign in with Apple" and "Sign in with Google" buttons.

Free Trial Offer: A screen promoting a free trial with a "Try for $0.00" button.

Discount Spinner: A promotional screen with a spinning wheel to "unlock an exclusive discount." This is a key visual component and should be animated.

Payment Screen: A final screen with a one-time offer, a toggle between monthly/yearly pricing, and a "Start Free Trial" button that triggers the App Store subscription sheet.

Instructions: The payment view needs to be a custom view that mimics the native App Store subscription UI, allowing the user to select a plan and then initiate the purchase.

2. Main Application Pages
After onboarding, the user is taken to the core functionality of the app.

1. Home Screen (Nutrition Dashboard)

Purpose: Provide a real-time overview of the user's daily nutrition.

Layout: A clean, minimal layout with a central card component.

Components:

Header: Contains the current time, a back arrow, and a language toggle.

Main Card:

Title: The name of the meal (e.g., "Turkey Sandwich With Potato Chips").

Image: A photo of the meal.

Serving Counter: A stepper with "+" and "-" buttons.

Nutrient Breakdown: A horizontal row of data points for Calories, Protein, Carbs, and Fats. Each has an icon and a value (e.g., "460 Cals").

Health Score: A progress bar and score (e.g., "7/10").

Action Buttons: "Fix Results" and "Done."

Food Scanner UI: A floating camera button at the bottom of the screen. Tapping it opens a camera view with a square frame and a bottom bar with "Scan Food," gallery, and manual entry options.

Progress Bar: A subtle, horizontal progress bar at the top right showing daily calorie consumption.

2. Progress/Plan Screen

Purpose: Display a summary of the user's plan and progress.

Layout: A vertical scroll view with clear, sectioned components.

Components:

Header: "Congratulations your custom plan is ready!"

Goal Summary: "You should lose: Lose 12 lbs by December 26."

Daily Recommendation Cards: Four distinct, rounded cards for Calories, Carbs, Protein, and Fats, each with a value, an icon, and a small pencil icon for editing.

Health Score Card: A dedicated card with a progress bar and score.

Goal Tips Section: A titled list "How to reach your goals:" with individual, icon-based tips in separate rows (e.g., "Track your food").

Source List: A final section with a list of the peer-reviewed sources used to create the plan.

3. General Design & Style Guide
Typography: Use a clean, sans-serif font throughout the app. Titles are large and bold, while body text is a lighter weight.

Color Palette: Dominated by a neutral black, white, and gray, with splashes of color (e.g., red for protein, yellow for carbs) to highlight key data points.

Icons: Use simple, minimalist line-art icons.

Rounded Corners: All buttons, cards, and containers have a significant rounded corner radius for a modern, soft feel.

Animations & Transitions: Screen transitions should be smooth. Progress bars, such as the Health Score and loading bar, must animate to provide a sense of progress.