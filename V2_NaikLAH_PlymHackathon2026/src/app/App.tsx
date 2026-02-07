import { useState } from "react";
import { ThemeProvider } from "./contexts/ThemeContext";
import LoginPage from "./components/LoginPage";
import SignUpPage from "./components/SignUpPage";
import ForgotPasswordPage from "./components/ForgotPasswordPage";
import ICVerificationPage from "./components/ICVerificationPage";
import NewMainDashboard from "./components/NewMainDashboard";
import TripLogging from "./components/TripLogging";
import RewardsPage from "./components/RewardsPage";
import UserProfile from "./components/UserProfile";

type ViewType =
  | "login"
  | "signup"
  | "forgotPassword"
  | "icVerification"
  | "dashboard"
  | "trips"
  | "rewards"
  | "profile";

interface UserProfile {
  name: string;
  email: string;
  phone: string;
  points: number;
  tier: string;
}

export default function App() {
  const [currentView, setCurrentView] = useState<ViewType>("login");
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);

  const handleLogin = (email: string, password: string) => {
    // Simulate login - In production, this would call an API
    console.log("Login attempt:", email, password);
    
    // Create a temporary user profile
    const tempProfile: UserProfile = {
      name: "Sarah Johnson",
      email: email,
      phone: "+1 (555) 123-4567",
      points: 2450,
      tier: "Gold",
    };
    
    setUserProfile(tempProfile);
    setCurrentView("icVerification");
  };

  const handleSignUp = (userData: {
    name: string;
    email: string;
    phone: string;
    password: string;
  }) => {
    // Simulate sign up - In production, this would call an API
    console.log("Sign up attempt:", userData);
    
    const newProfile: UserProfile = {
      name: userData.name,
      email: userData.email,
      phone: userData.phone,
      points: 0,
      tier: "Bronze",
    };
    
    setUserProfile(newProfile);
    setCurrentView("icVerification");
  };

  const handleVerificationComplete = () => {
    setCurrentView("dashboard");
  };

  const handleLogout = () => {
    setUserProfile(null);
    setCurrentView("login");
  };

  const handleNavigate = (view: string) => {
    if (view === "home") {
      setCurrentView("dashboard");
    } else if (view === "trips") {
      setCurrentView("trips");
    } else if (view === "rewards") {
      setCurrentView("rewards");
    } else if (view === "profile") {
      setCurrentView("profile");
    }
  };

  const handleBackToDashboard = () => {
    setCurrentView("dashboard");
  };

  return (
    <ThemeProvider>
      <div className="min-h-screen bg-gray-50">
        {currentView === "login" && (
          <LoginPage
            onLogin={handleLogin}
            onNavigateToSignup={() => setCurrentView("signup")}
            onForgotPassword={() => setCurrentView("forgotPassword")}
          />
        )}

        {currentView === "signup" && (
          <SignUpPage
            onSignUp={handleSignUp}
            onNavigateToLogin={() => setCurrentView("login")}
          />
        )}

        {currentView === "forgotPassword" && (
          <ForgotPasswordPage onBack={() => setCurrentView("login")} />
        )}

        {currentView === "icVerification" && userProfile && (
          <ICVerificationPage
            onVerificationComplete={handleVerificationComplete}
            userName={userProfile.name}
          />
        )}

        {currentView === "dashboard" && userProfile && (
          <NewMainDashboard
            userProfile={userProfile}
            onNavigate={handleNavigate}
          />
        )}

        {currentView === "trips" && userProfile && (
          <TripLogging
            userProfile={userProfile}
            onNavigate={handleBackToDashboard}
          />
        )}

        {currentView === "rewards" && userProfile && (
          <RewardsPage
            userProfile={userProfile}
            onNavigate={handleBackToDashboard}
          />
        )}

        {currentView === "profile" && userProfile && (
          <UserProfile
            userProfile={userProfile}
            onBack={handleBackToDashboard}
            onLogout={handleLogout}
          />
        )}
      </div>
    </ThemeProvider>
  );
}
