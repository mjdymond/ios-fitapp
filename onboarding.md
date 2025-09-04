This document outlines the pages and components of the Cal AI onboarding flow, serving as a guide for a coding agent to replicate the process in Swift.

Page 1: Welcome Screen
Requirements:

A full-screen banner image showing a person's meal with calorie information overlaid.

The title "Calorie tracking made easy" is centered below the image.

A prominent, rounded "Get Started" button at the bottom of the screen.

Instructions:

Create a view with an image as a background or large foreground element.

Use a large, bold font for the title.

The "Get Started" button should be black with white text and have a large, rounded corner radius.

Page 2: Gender Selection
Requirements:

The title "Choose your Gender" is at the top.

A descriptive subtitle, "This will be used to calibrate your custom plan," is below the title.

Three rectangular buttons for "Male," "Female," and "Other."

Instructions:

Implement a vertically stacked view.

The buttons should be a light gray with dark gray text.

When a button is selected, it turns black with white text.

The buttons should have rounded corners and be horizontally centered.

Page 3: Workout Frequency
Requirements:

The title "How many workouts do you do per week?" is at the top.

A descriptive subtitle, "This will be used to calibrate your custom plan," is below the title.

Three selectable options, each with a bullet point and descriptive text:

"0-2 Workouts now and then"

"3-5 A few workouts per week"

"6+ Dedicated athlete"

Instructions:

Use a vertically stacked list or series of buttons.

Unselected items are a light gray with a gray bullet point.

When an item is selected, the entire container becomes black, and the text and bullet point turn white. The bullet point icon should be filled in when selected.

Page 4: User Demographics
Requirements:

Source of Referral: A full-screen list with multiple options (TV, Youtube, etc.). Tapping an option selects it.

Prior App Usage: Two buttons, "No" and "Yes," with thumbs-up/down icons. Tapping selects the option.

Weight & Height: Imperial and Metric system toggle. The user can scroll through a list of values to select their height (feet and inches) and weight (pounds).

Date of Birth: A date picker allows the user to scroll to select the month, day, and year.

Instructions:

Create separate views for each of these sections.

The Imperial/Metric toggle should be a switch that changes the units displayed.

Use a UIPickerView or similar component for the scrolling lists for height, weight, and date of birth.

Page 5: Goal Setting
Requirements:

Goal Type: Three buttons for "Lose weight," "Maintain," and "Gain weight."

Desired Weight: A scrollable weight picker that lets the user set their target weight. It shows the difference between the current weight and the target weight.

Weight Loss Speed: A horizontal slider with icons representing different speeds (e.g., a sloth for slow, a rabbit for moderate, a cheetah for fast). A recommended speed is highlighted.

Instructions:

The weight loss speed slider should have a visual representation of the selected speed (e.g., "1.0 lbs").

The "Losing 12 lbs is a realistic target. It's not hard at all!" screen should appear after the desired weight is set.

The UIView displaying the weight loss speed should update dynamically as the slider is moved.

Display the "Lose twice as much weight..." page as a promotional interlude.

Page 6: Obstacles & Preferences
Requirements:

Obstacles: A list of potential obstacles with icons, such as "Lack of consistency," "Unhealthy eating habits," etc. Multiple options can be selected.

Diet Type: A list of diet options (Classic, Pescatarian, Vegetarian, Vegan).

Accomplishments: A list of goals the user wants to accomplish (e.g., "Eat and live healthier," "Boost my energy and mood").

Instructions:

Implement selectable list items similar to the gender selection page.

Ensure the selected items are visually distinct from unselected ones.

Page 7: Plan Generation
Requirements:

A series of screens that display a weight transition chart as if it's being generated.

A "Thank you for trusting us" screen with a brief message about privacy and security.

A screen to "Connect to Apple Health."

A screen to prompt the user to "Add calories burned back to your daily goal?" and a "Rollover extra calories" screen.

A screen prompting a 5-star rating, including reviews from other users.

A screen for enabling push notifications.

A screen for entering a referral code.

A final loading screen with a percentage bar and a checklist of "Daily recommendation" items.

Instructions:

Use animations to simulate the weight transition chart being drawn.

For the Apple Health connection, display a system pop-up requesting access to various health data points.

The rating screen should be a custom view with a modal pop-up for the user to rate the app.

The loading screen should have a progress bar that animates from 0% to 100%.

Page 8: Final Plan & Subscription
Requirements:

A "Congratulations your custom plan is ready!" screen.

The daily recommendation is displayed with specific calorie, carb, protein, and fat counts.

A section on "How to reach your goals" with actionable tips.

A list of the sources used to generate the plan.

A screen to "Save your progress" with "Sign in with Apple" and "Sign in with Google" buttons.

A "Try CalAI for free" screen with a 3-day trial offer.

A "Spin to unlock an exclusive discount" screen.

A final payment screen with a one-time offer and a Start Free Trial button.

Instructions:

The final plan screen should be a detailed summary of the user's plan.

The sign-in buttons should trigger the respective authentication flows.

The "spin to unlock" screen is a visually engaging component with an animated spinning wheel.

The final payment screen should display pricing for a monthly and yearly plan, with the yearly plan highlighted as a better deal.

The "Start Free Trial" button should initiate the payment process, which for iOS would use the App Store subscription sheet.