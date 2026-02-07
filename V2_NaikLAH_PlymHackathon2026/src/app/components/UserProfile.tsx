import { useState } from "react";
import {
  User,
  Mail,
  Phone,
  MapPin,
  Award,
  Settings,
  Eye,
  Type,
  Volume2,
  Palette,
  LogOut,
  Edit,
  ArrowLeft,
  Check,
} from "lucide-react";
import { useTheme, ThemeColor } from "../contexts/ThemeContext";

interface UserProfileProps {
  userProfile: {
    name: string;
    email: string;
    phone: string;
    points: number;
    tier: string;
  };
  onBack: () => void;
  onLogout: () => void;
}

export default function UserProfile({
  userProfile,
  onBack,
  onLogout,
}: UserProfileProps) {
  const { theme, setTheme, colors } = useTheme();
  const [activeSection, setActiveSection] = useState<
    "profile" | "settings"
  >("profile");
  const [accessibilitySettings, setAccessibilitySettings] =
    useState({
      colorblindMode: "none",
      fontSize: "medium",
      highContrast: false,
      screenReader: false,
      reduceMotion: false,
    });

  const tierBenefits = {
    Bronze: {
      multiplier: "1x",
      color: "text-orange-700 bg-orange-100",
    },
    Silver: {
      multiplier: "1.5x",
      color: "text-gray-700 bg-gray-200",
    },
    Gold: {
      multiplier: "2x",
      color: "text-amber-700 bg-amber-100",
    },
    Platinum: {
      multiplier: "3x",
      color: "text-purple-700 bg-purple-100",
    },
  };

  const currentTier =
    tierBenefits[
      userProfile.tier as keyof typeof tierBenefits
    ] || tierBenefits.Bronze;

  const handleSettingChange = (setting: string, value: any) => {
    setAccessibilitySettings((prev) => ({
      ...prev,
      [setting]: value,
    }));
  };

  const getThemeGradient = () => {
    switch (theme) {
      case "blue":
        return "from-blue-600 to-cyan-600";
      case "pink":
        return "from-pink-600 to-rose-600";
      case "black":
        return "from-gray-900 to-gray-700";
      default:
        return "from-blue-600 to-cyan-600";
    }
  };

  const themeOptions: {
    value: ThemeColor;
    label: string;
    preview: string;
  }[] = [
    {
      value: "blue",
      label: "Ocean Blue",
      preview: "bg-gradient-to-r from-blue-600 to-cyan-600",
    },
    {
      value: "pink",
      label: "Rose Pink",
      preview: "bg-gradient-to-r from-pink-600 to-rose-600",
    },
    {
      value: "black",
      label: "Dark Mode",
      preview: "bg-gradient-to-r from-gray-900 to-gray-700",
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50 pb-6">
      {/* Header */}
      <div
        className={`bg-gradient-to-r ${getThemeGradient()} text-white p-6 rounded-b-3xl shadow-lg mb-6`}
      >
        <button
          onClick={onBack}
          className="flex items-center text-white/90 hover:text-white mb-4 transition-colors"
        >
          <ArrowLeft className="w-5 h-5 mr-2" />
          Back
        </button>
        <div className="text-center">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-white/20 backdrop-blur-sm rounded-full mb-3 border border-white/30">
            <User className="w-10 h-10" />
          </div>
          <h1 className="text-2xl font-bold mb-1">
            {userProfile.name}
          </h1>
          <p className="text-white/80">{userProfile.email}</p>
        </div>
      </div>

      {/* Section Tabs */}
      <div className="px-4 mb-6">
        <div className="bg-white rounded-xl shadow-md p-1 flex border border-gray-100">
          <button
            onClick={() => setActiveSection("profile")}
            className={`flex-1 py-3 rounded-lg font-medium transition-all ${
              activeSection === "profile"
                ? `${colors.primary} text-white`
                : "text-gray-600 hover:text-gray-900"
            }`}
          >
            Profile Details
          </button>
          <button
            onClick={() => setActiveSection("settings")}
            className={`flex-1 py-3 rounded-lg font-medium transition-all ${
              activeSection === "settings"
                ? `${colors.primary} text-white`
                : "text-gray-600 hover:text-gray-900"
            }`}
          >
            Settings
          </button>
        </div>
      </div>

      <div className="px-4 space-y-4">
        {activeSection === "profile" && (
          <>
            {/* Personal Information */}
            <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
              <div className="bg-gray-50 px-4 py-3 border-b border-gray-200 flex items-center justify-between">
                <h2 className="font-bold text-gray-900">
                  Personal Information
                </h2>
                <button
                  className={`text-${theme === "blue" ? "blue" : theme === "pink" ? "pink" : "gray"}-600 hover:opacity-80`}
                >
                  <Edit className="w-5 h-5" />
                </button>
              </div>
              <div className="divide-y divide-gray-100">
                <div className="px-4 py-4 flex items-center space-x-3">
                  <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <User className="w-5 h-5 text-blue-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-xs text-gray-500">
                      Full Name
                    </p>
                    <p className="font-medium text-gray-900">
                      {userProfile.name}
                    </p>
                  </div>
                </div>
                <div className="px-4 py-4 flex items-center space-x-3">
                  <div className="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <Mail className="w-5 h-5 text-purple-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-xs text-gray-500">
                      Email
                    </p>
                    <p className="font-medium text-gray-900">
                      {userProfile.email}
                    </p>
                  </div>
                </div>
                <div className="px-4 py-4 flex items-center space-x-3">
                  <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <Phone className="w-5 h-5 text-green-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-xs text-gray-500">
                      Phone
                    </p>
                    <p className="font-medium text-gray-900">
                      {userProfile.phone || "+1 (555) 123-4567"}
                    </p>
                  </div>
                </div>
                <div className="px-4 py-4 flex items-center space-x-3">
                  <div className="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <MapPin className="w-5 h-5 text-orange-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-xs text-gray-500">
                      Location
                    </p>
                    <p className="font-medium text-gray-900">
                      Kuala Lumpur, Malaysia
                    </p>
                  </div>
                </div>
              </div>
            </div>

            {/* Loyalty Tier */}
            <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
              <div className="bg-gray-50 px-4 py-3 border-b border-gray-200">
                <h2 className="font-bold text-gray-900">
                  Loyalty Tier
                </h2>
              </div>
              <div className="p-6">
                <div className="flex items-center justify-between mb-4">
                  <div>
                    <div
                      className={`inline-block px-4 py-2 rounded-full ${currentTier.color} font-bold text-lg mb-2`}
                    >
                      {userProfile.tier}
                    </div>
                    <p className="text-sm text-gray-600">
                      Points Multiplier:{" "}
                      {currentTier.multiplier}
                    </p>
                  </div>
                  <Award className="w-12 h-12 text-gray-300" />
                </div>

                {/* Points Progress */}
                <div className="mb-4">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm font-medium text-gray-700">
                      Current Points
                    </span>
                    <span className="text-sm font-bold text-green-600">
                      {userProfile.points.toLocaleString()}
                    </span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                    <div
                      className={`bg-gradient-to-r ${getThemeGradient()} h-full rounded-full transition-all duration-500`}
                      style={{
                        width: `${Math.min((userProfile.points / 5000) * 100, 100)}%`,
                      }}
                    ></div>
                  </div>
                  <p className="text-xs text-gray-500 mt-1">
                    {5000 - userProfile.points > 0
                      ? `${5000 - userProfile.points} points to next tier`
                      : "Maximum tier reached"}
                  </p>
                </div>

                {/* Tier Benefits */}
                <div className="bg-green-50 rounded-lg p-4 border border-green-100">
                  <p className="text-sm font-medium text-green-900 mb-2">
                    Your Benefits:
                  </p>
                  <ul className="text-xs text-green-800 space-y-1">
                    <li className="flex items-center">
                      <Check className="w-3 h-3 mr-1" />{" "}
                      {currentTier.multiplier} points on all
                      trips
                    </li>
                    <li className="flex items-center">
                      <Check className="w-3 h-3 mr-1" />{" "}
                      Priority booking
                    </li>
                    <li className="flex items-center">
                      <Check className="w-3 h-3 mr-1" />{" "}
                      Exclusive rewards access
                    </li>
                    {userProfile.tier !== "Bronze" && (
                      <li className="flex items-center">
                        <Check className="w-3 h-3 mr-1" />{" "}
                        Monthly bonus points
                      </li>
                    )}
                  </ul>
                </div>
              </div>
            </div>

            {/* Statistics */}
            <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
              <div className="bg-gray-50 px-4 py-3 border-b border-gray-200">
                <h2 className="font-bold text-gray-900">
                  Your Impact
                </h2>
              </div>
              <div className="grid grid-cols-2 divide-x divide-gray-100">
                <div className="p-4 text-center">
                  <p className="text-2xl font-bold text-green-600">
                    127
                  </p>
                  <p className="text-xs text-gray-600">
                    Total Trips
                  </p>
                </div>
                <div className="p-4 text-center">
                  <p className="text-2xl font-bold text-blue-600">
                    245 kg
                  </p>
                  <p className="text-xs text-gray-600">
                    CO₂ Saved
                  </p>
                </div>
              </div>
            </div>
          </>
        )}

        {activeSection === "settings" && (
          <>
            {/* Theme Selection */}
            <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
              <div className="bg-gray-50 px-4 py-3 border-b border-gray-200">
                <h2 className="font-bold text-gray-900">
                  Theme Color
                </h2>
              </div>
              <div className="p-4 space-y-3">
                {themeOptions.map((option) => (
                  <button
                    key={option.value}
                    onClick={() => setTheme(option.value)}
                    className={`w-full flex items-center justify-between p-4 rounded-xl border-2 transition-all ${
                      theme === option.value
                        ? "border-gray-900 bg-gray-50"
                        : "border-gray-200 hover:border-gray-300"
                    }`}
                  >
                    <div className="flex items-center space-x-3">
                      <div
                        className={`w-12 h-12 rounded-lg ${option.preview} shadow-md`}
                      ></div>
                      <div className="text-left">
                        <p className="font-medium text-gray-900">
                          {option.label}
                        </p>
                        <p className="text-xs text-gray-500">
                          {theme === option.value
                            ? "Currently selected"
                            : "Click to apply"}
                        </p>
                      </div>
                    </div>
                    {theme === option.value && (
                      <div className="w-6 h-6 bg-gray-900 rounded-full flex items-center justify-center">
                        <Check className="w-4 h-4 text-white" />
                      </div>
                    )}
                  </button>
                ))}
              </div>
            </div>

            {/* Accessibility Settings */}
            <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
              <div className="bg-gray-50 px-4 py-3 border-b border-gray-200">
                <h2 className="font-bold text-gray-900">
                  Accessibility Options
                </h2>
              </div>

              {/* Colorblind Mode */}
              <div className="p-4 border-b border-gray-100">
                <div className="flex items-center space-x-3 mb-3">
                  <Palette className="w-5 h-5 text-purple-600" />
                  <h3 className="font-medium text-gray-900">
                    Colorblind Mode
                  </h3>
                </div>
                <select
                  value={accessibilitySettings.colorblindMode}
                  onChange={(e) =>
                    handleSettingChange(
                      "colorblindMode",
                      e.target.value,
                    )
                  }
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="none">None</option>
                  <option value="protanopia">
                    Protanopia (Red-blind)
                  </option>
                  <option value="deuteranopia">
                    Deuteranopia (Green-blind)
                  </option>
                  <option value="tritanopia">
                    Tritanopia (Blue-blind)
                  </option>
                </select>
              </div>

              {/* Font Size */}
              <div className="p-4 border-b border-gray-100">
                <div className="flex items-center space-x-3 mb-3">
                  <Type className="w-5 h-5 text-blue-600" />
                  <h3 className="font-medium text-gray-900">
                    Font Size
                  </h3>
                </div>
                <div className="grid grid-cols-4 gap-2">
                  {[
                    "small",
                    "medium",
                    "large",
                    "extra-large",
                  ].map((size) => (
                    <button
                      key={size}
                      onClick={() =>
                        handleSettingChange("fontSize", size)
                      }
                      className={`py-2 px-3 rounded-lg border transition-all ${
                        accessibilitySettings.fontSize === size
                          ? `${colors.primary} text-white border-transparent`
                          : "bg-white text-gray-700 border-gray-300 hover:border-gray-400"
                      }`}
                    >
                      <span
                        className={
                          size === "small"
                            ? "text-xs"
                            : size === "medium"
                              ? "text-sm"
                              : size === "large"
                                ? "text-base"
                                : "text-lg"
                        }
                      >
                        A
                      </span>
                    </button>
                  ))}
                </div>
              </div>

              {/* High Contrast */}
              <div className="p-4 border-b border-gray-100">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <Eye className="w-5 h-5 text-orange-600" />
                    <div>
                      <h3 className="font-medium text-gray-900">
                        High Contrast
                      </h3>
                      <p className="text-xs text-gray-600">
                        Enhance visual clarity
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={() =>
                      handleSettingChange(
                        "highContrast",
                        !accessibilitySettings.highContrast,
                      )
                    }
                    className={`relative w-12 h-6 rounded-full transition-colors ${
                      accessibilitySettings.highContrast
                        ? colors.primary
                        : "bg-gray-300"
                    }`}
                  >
                    <div
                      className={`absolute top-1 left-1 w-4 h-4 bg-white rounded-full transition-transform shadow-sm ${
                        accessibilitySettings.highContrast
                          ? "translate-x-6"
                          : ""
                      }`}
                    ></div>
                  </button>
                </div>
              </div>

              {/* Screen Reader Support */}
              <div className="p-4 border-b border-gray-100">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <Volume2 className="w-5 h-5 text-green-600" />
                    <div>
                      <h3 className="font-medium text-gray-900">
                        Screen Reader Support
                      </h3>
                      <p className="text-xs text-gray-600">
                        Optimize for screen readers
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={() =>
                      handleSettingChange(
                        "screenReader",
                        !accessibilitySettings.screenReader,
                      )
                    }
                    className={`relative w-12 h-6 rounded-full transition-colors ${
                      accessibilitySettings.screenReader
                        ? colors.primary
                        : "bg-gray-300"
                    }`}
                  >
                    <div
                      className={`absolute top-1 left-1 w-4 h-4 bg-white rounded-full transition-transform shadow-sm ${
                        accessibilitySettings.screenReader
                          ? "translate-x-6"
                          : ""
                      }`}
                    ></div>
                  </button>
                </div>
              </div>

              {/* Reduce Motion */}
              <div className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <Settings className="w-5 h-5 text-gray-600" />
                    <div>
                      <h3 className="font-medium text-gray-900">
                        Reduce Motion
                      </h3>
                      <p className="text-xs text-gray-600">
                        Minimize animations
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={() =>
                      handleSettingChange(
                        "reduceMotion",
                        !accessibilitySettings.reduceMotion,
                      )
                    }
                    className={`relative w-12 h-6 rounded-full transition-colors ${
                      accessibilitySettings.reduceMotion
                        ? colors.primary
                        : "bg-gray-300"
                    }`}
                  >
                    <div
                      className={`absolute top-1 left-1 w-4 h-4 bg-white rounded-full transition-transform shadow-sm ${
                        accessibilitySettings.reduceMotion
                          ? "translate-x-6"
                          : ""
                      }`}
                    ></div>
                  </button>
                </div>
              </div>
            </div>

            {/* Accessibility Info */}
            <div className="bg-blue-50 rounded-xl p-4 border border-blue-100">
              <p className="text-sm text-blue-900 font-medium mb-2">
                Need help?
              </p>
              <p className="text-xs text-blue-800">
                Our platform is designed to be accessible to
                everyone. If you encounter any barriers, please
                contact our support team.
              </p>
            </div>
          </>
        )}

        {/* Logout Button */}
        <button
          onClick={onLogout}
          className="w-full bg-red-600 hover:bg-red-700 text-white py-4 rounded-xl font-medium transition-all shadow-lg hover:shadow-xl flex items-center justify-center space-x-2 transform hover:-translate-y-0.5"
        >
          <LogOut className="w-5 h-5" />
          <span>Log Out</span>
        </button>
      </div>
    </div>
  );
}