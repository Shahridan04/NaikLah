import { useState } from "react";
import { Home, Gift, User, MapPin, Leaf, Award, TrendingUp } from "lucide-react";
import { useTheme } from "../contexts/ThemeContext";

interface DashboardProps {
  userProfile: {
    name: string;
    email: string;
    points: number;
    tier: string;
  };
  onNavigate: (view: string) => void;
}

export default function NewMainDashboard({
  userProfile,
  onNavigate,
}: DashboardProps) {
  const { theme, colors } = useTheme();
  const [activeTab, setActiveTab] = useState("home");
  const [currentSlide, setCurrentSlide] = useState(0);

  const getThemeGradient = () => {
    switch(theme) {
      case 'blue':
        return 'from-blue-600 to-cyan-600';
      case 'pink':
        return 'from-pink-600 to-rose-600';
      case 'black':
        return 'from-gray-900 to-gray-700';
      default:
        return 'from-blue-600 to-cyan-600';
    }
  };

  const carouselItems = [
    {
      title: "Track Your Impact",
      description: "Every sustainable trip makes a difference",
      icon: Leaf,
      color: "from-green-500 to-emerald-600",
    },
    {
      title: "Earn Rewards",
      description: "Get points for eco-friendly travel",
      icon: Award,
      color: "from-purple-500 to-indigo-600",
    },
    {
      title: "Women's Safety First",
      description: "Safe commuting for everyone",
      icon: MapPin,
      color: "from-pink-500 to-rose-600",
    },
  ];

  const highlights = [
    {
      label: "Total Points",
      value: userProfile.points.toLocaleString(),
      icon: Award,
      color: "bg-amber-100 text-amber-700",
    },
    {
      label: "CO₂ Saved",
      value: "45.2 kg",
      icon: Leaf,
      color: "bg-green-100 text-green-700",
    },
    {
      label: "Trips This Week",
      value: "12",
      icon: TrendingUp,
      color: "bg-blue-100 text-blue-700",
    },
  ];

  const navItems = [
    { id: "home", label: "Home", icon: Home },
    { id: "trips", label: "Trips", icon: MapPin },
    { id: "rewards", label: "Rewards", icon: Gift },
    { id: "profile", label: "Profile", icon: User },
  ];

  const handleNavClick = (itemId: string) => {
    setActiveTab(itemId);
    if (itemId !== "home") {
      onNavigate(itemId);
    }
  };

  const nextSlide = () => {
    setCurrentSlide((prev) => (prev + 1) % carouselItems.length);
  };

  const prevSlide = () => {
    setCurrentSlide(
      (prev) => (prev - 1 + carouselItems.length) % carouselItems.length
    );
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Header */}
      <div className={`bg-gradient-to-r ${getThemeGradient()} text-white p-6 rounded-b-3xl shadow-lg`}>
        <div className="flex items-center justify-between mb-4">
          <div>
            <h1 className="text-2xl font-bold">Welcome back,</h1>
            <p className="text-white/80">{userProfile.name}</p>
          </div>
          <div className="bg-white/20 backdrop-blur-sm px-4 py-2 rounded-full border border-white/30">
            <p className="text-xs text-white/70">Tier</p>
            <p className="font-bold">{userProfile.tier}</p>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="px-4 -mt-8">
        {/* Carousel */}
        <div className="bg-white rounded-2xl shadow-xl overflow-hidden mb-6 border border-gray-100">
          <div className="relative h-48">
            {carouselItems.map((item, index) => (
              <div
                key={index}
                className={`absolute inset-0 transition-all duration-500 ${
                  index === currentSlide
                    ? "opacity-100 translate-x-0"
                    : index < currentSlide
                    ? "opacity-0 -translate-x-full"
                    : "opacity-0 translate-x-full"
                }`}
              >
                <div
                  className={`h-full bg-gradient-to-br ${item.color} p-6 flex flex-col justify-between`}
                >
                  <div className="flex items-start justify-between">
                    <div>
                      <h3 className="text-2xl font-bold text-white mb-2">
                        {item.title}
                      </h3>
                      <p className="text-white/90">{item.description}</p>
                    </div>
                    <item.icon className="w-12 h-12 text-white/80" />
                  </div>
                </div>
              </div>
            ))}

            {/* Carousel Controls */}
            <button
              onClick={prevSlide}
              className="absolute left-2 top-1/2 -translate-y-1/2 bg-white/30 hover:bg-white/50 backdrop-blur-sm text-white w-8 h-8 rounded-full flex items-center justify-center transition-all"
              aria-label="Previous slide"
            >
              <span className="text-lg">‹</span>
            </button>
            <button
              onClick={nextSlide}
              className="absolute right-2 top-1/2 -translate-y-1/2 bg-white/30 hover:bg-white/50 backdrop-blur-sm text-white w-8 h-8 rounded-full flex items-center justify-center transition-all"
              aria-label="Next slide"
            >
              <span className="text-lg">›</span>
            </button>

            {/* Carousel Indicators */}
            <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex space-x-2">
              {carouselItems.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setCurrentSlide(index)}
                  className={`h-2 rounded-full transition-all ${
                    index === currentSlide
                      ? "bg-white w-6"
                      : "bg-white/50 hover:bg-white/75 w-2"
                  }`}
                  aria-label={`Go to slide ${index + 1}`}
                />
              ))}
            </div>
          </div>
        </div>

        {/* Highlights Section */}
        <div className="mb-6">
          <h2 className="text-lg font-bold text-gray-900 mb-4">
            Your Impact Highlights
          </h2>
          <div className="grid grid-cols-3 gap-4">
            {highlights.map((highlight, index) => (
              <div
                key={index}
                className="bg-white rounded-xl shadow-md p-4 text-center border border-gray-100 hover:shadow-lg transition-shadow"
              >
                <div
                  className={`inline-flex items-center justify-center w-10 h-10 ${highlight.color} rounded-full mb-2`}
                >
                  <highlight.icon className="w-5 h-5" />
                </div>
                <p className="text-2xl font-bold text-gray-900">
                  {highlight.value}
                </p>
                <p className="text-xs text-gray-600">{highlight.label}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Quick Actions */}
        <div className="mb-6">
          <h2 className="text-lg font-bold text-gray-900 mb-4">
            Quick Actions
          </h2>
          <div className="grid grid-cols-2 gap-4">
            <button
              onClick={() => onNavigate("trips")}
              className="bg-gradient-to-br from-green-500 to-emerald-600 text-white p-6 rounded-2xl shadow-lg hover:shadow-xl transition-all transform hover:-translate-y-1"
            >
              <MapPin className="w-8 h-8 mb-2" />
              <p className="font-bold">Log Trip</p>
              <p className="text-xs text-green-100">Earn points</p>
            </button>
            <button
              onClick={() => onNavigate("rewards")}
              className="bg-gradient-to-br from-purple-500 to-indigo-600 text-white p-6 rounded-2xl shadow-lg hover:shadow-xl transition-all transform hover:-translate-y-1"
            >
              <Gift className="w-8 h-8 mb-2" />
              <p className="font-bold">Rewards</p>
              <p className="text-xs text-purple-100">Redeem points</p>
            </button>
          </div>
        </div>

        {/* Recent Activity */}
        <div className="mb-6">
          <h2 className="text-lg font-bold text-gray-900 mb-4">
            Recent Activity
          </h2>
          <div className="bg-white rounded-xl shadow-md divide-y border border-gray-100">
            {[
              {
                type: "Bus",
                route: "Route 12",
                points: "+50",
                time: "2 hours ago",
              },
              {
                type: "Walk",
                route: "1.2 km walk",
                points: "+20",
                time: "Yesterday",
              },
              {
                type: "Carpool",
                route: "Shared ride",
                points: "+35",
                time: "2 days ago",
              },
            ].map((activity, index) => (
              <div key={index} className="p-4 flex items-center justify-between hover:bg-gray-50 transition-colors">
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                    <MapPin className="w-5 h-5 text-green-600" />
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">{activity.type}</p>
                    <p className="text-sm text-gray-600">{activity.route}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="font-bold text-green-600">{activity.points}</p>
                  <p className="text-xs text-gray-500">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-6 py-3 shadow-2xl">
        <div className="flex items-center justify-around max-w-md mx-auto">
          {navItems.map((item) => {
            const isActive = activeTab === item.id;
            const getActiveColor = () => {
              switch(theme) {
                case 'blue': return 'text-blue-600';
                case 'pink': return 'text-pink-600';
                case 'black': return 'text-gray-900';
                default: return 'text-blue-600';
              }
            };
            
            return (
              <button
                key={item.id}
                onClick={() => handleNavClick(item.id)}
                className={`flex flex-col items-center space-y-1 px-4 py-2 rounded-lg transition-all duration-300 transform ${
                  isActive
                    ? `${getActiveColor()} scale-110 -translate-y-1`
                    : "text-gray-500 hover:text-gray-700 hover:scale-105"
                }`}
              >
                <item.icon
                  className={`w-6 h-6 transition-all duration-300 ${
                    isActive ? "stroke-[2.5]" : "stroke-2"
                  }`}
                />
                <span className="text-xs font-medium">{item.label}</span>
                {isActive && (
                  <div className={`w-1 h-1 ${colors.primary} rounded-full`}></div>
                )}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
