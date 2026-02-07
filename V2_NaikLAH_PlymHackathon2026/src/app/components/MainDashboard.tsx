import { useState } from 'react';
import { 
  Award, 
  TrendingUp, 
  Flame, 
  Leaf, 
  Star, 
  Trophy,
  Bus,
  Gift,
  QrCode,
  Menu,
  X,
  User,
  Shield
} from 'lucide-react';

interface MainDashboardProps {
  userProfile: any;
  onNavigate: (view: string) => void;
}

export default function MainDashboard({ userProfile, onNavigate }: MainDashboardProps) {
  const [menuOpen, setMenuOpen] = useState(false);

  // Mock user stats
  const userStats = {
    totalPoints: 1250,
    currentStreak: 10,
    co2Saved: 12.5,
    totalTrips: 28,
    rank: 5,
    level: 3,
    nextLevelPoints: 1500,
  };

  const recentTrips = [
    { id: 1, mode: 'Pink Bus', date: 'Today, 8:30 AM', points: 50, co2: 0.8 },
    { id: 2, mode: 'LRT', date: 'Today, 6:00 PM', points: 40, co2: 0.6 },
    { id: 3, mode: 'Walking', date: 'Yesterday, 12:15 PM', points: 30, co2: 0.0 },
    { id: 4, mode: 'Pink Bus', date: 'Yesterday, 8:30 AM', points: 50, co2: 0.8 },
  ];

  const leaderboard = [
    { rank: 1, name: 'Sarah Wong', points: 2150, avatar: '👩' },
    { rank: 2, name: 'Aisha Rahman', points: 1980, avatar: '👩' },
    { rank: 3, name: 'Michelle Tan', points: 1750, avatar: '👩' },
    { rank: 4, name: 'David Lee', points: 1450, avatar: '👨' },
    { rank: 5, name: `${userProfile?.name || 'You'}`, points: 1250, avatar: '⭐', isCurrentUser: true },
  ];

  const achievements = [
    { id: 1, title: 'Week Warrior', description: '7-day streak', earned: true, icon: '🔥' },
    { id: 2, title: 'Eco Champion', description: 'Saved 10kg CO2', earned: true, icon: '🌱' },
    { id: 3, title: 'Pink Bus Pioneer', description: 'Used pink bus 20 times', earned: false, icon: '💖' },
    { id: 4, title: 'Top 10', description: 'Reached top 10 leaderboard', earned: true, icon: '🏆' },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Navigation Bar */}
      <nav className="bg-white shadow-md sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center gap-2">
              <Leaf className="w-8 h-8 text-green-600" />
              <h1 className="text-2xl font-bold text-gray-900">EcoRide</h1>
            </div>
            
            <div className="hidden md:flex items-center gap-6">
              <button
                onClick={() => onNavigate('dashboard')}
                className="text-pink-600 font-semibold border-b-2 border-pink-600 pb-1"
              >
                Dashboard
              </button>
              <button
                onClick={() => onNavigate('trip')}
                className="text-gray-600 hover:text-gray-900 font-semibold"
              >
                Log Trip
              </button>
              <button
                onClick={() => onNavigate('rewards')}
                className="text-gray-600 hover:text-gray-900 font-semibold"
              >
                Rewards
              </button>
              <div className="flex items-center gap-2 bg-pink-100 px-4 py-2 rounded-full">
                <Star className="w-5 h-5 text-pink-600" />
                <span className="font-bold text-pink-900">{userStats.totalPoints} pts</span>
              </div>
            </div>

            <button
              onClick={() => setMenuOpen(!menuOpen)}
              className="md:hidden text-gray-600"
            >
              {menuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>

          {/* Mobile Menu */}
          {menuOpen && (
            <div className="md:hidden pb-4 space-y-2">
              <button
                onClick={() => { onNavigate('dashboard'); setMenuOpen(false); }}
                className="block w-full text-left px-4 py-2 text-pink-600 font-semibold bg-pink-50 rounded-lg"
              >
                Dashboard
              </button>
              <button
                onClick={() => { onNavigate('trip'); setMenuOpen(false); }}
                className="block w-full text-left px-4 py-2 text-gray-600 hover:bg-gray-50 rounded-lg"
              >
                Log Trip
              </button>
              <button
                onClick={() => { onNavigate('rewards'); setMenuOpen(false); }}
                className="block w-full text-left px-4 py-2 text-gray-600 hover:bg-gray-50 rounded-lg"
              >
                Rewards
              </button>
            </div>
          )}
        </div>
      </nav>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Welcome Section */}
        <div className="mb-8">
          <h2 className="text-3xl font-bold text-gray-900 mb-2">
            Welcome back, {userProfile?.name?.split(' ')[0] || 'Lisa'}! 👋
          </h2>
          <p className="text-gray-600">
            {userProfile?.company || 'PKT Logistics'} • Level {userStats.level} Eco Warrior
          </p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {/* Total Points */}
          <div className="bg-gradient-to-br from-purple-500 to-purple-700 text-white rounded-2xl p-6 shadow-lg">
            <div className="flex justify-between items-start mb-4">
              <Award className="w-8 h-8" />
              <div className="bg-white/20 px-3 py-1 rounded-full text-sm">Level {userStats.level}</div>
            </div>
            <div className="text-4xl font-bold mb-1">{userStats.totalPoints}</div>
            <div className="text-purple-100 mb-3">Total Points</div>
            <div className="bg-white/20 rounded-full h-2 mb-2">
              <div 
                className="bg-white rounded-full h-2"
                style={{ width: `${(userStats.totalPoints / userStats.nextLevelPoints) * 100}%` }}
              />
            </div>
            <div className="text-sm text-purple-100">
              {userStats.nextLevelPoints - userStats.totalPoints} pts to Level {userStats.level + 1}
            </div>
          </div>

          {/* Current Streak */}
          <div className="bg-gradient-to-br from-orange-500 to-red-600 text-white rounded-2xl p-6 shadow-lg">
            <div className="flex justify-between items-start mb-4">
              <Flame className="w-8 h-8" />
            </div>
            <div className="text-4xl font-bold mb-1">{userStats.currentStreak}</div>
            <div className="text-orange-100 mb-2">Day Streak 🔥</div>
            <div className="text-sm text-orange-100">
              Keep it going! Log a trip today to maintain your streak.
            </div>
          </div>

          {/* CO2 Saved */}
          <div className="bg-gradient-to-br from-green-500 to-emerald-700 text-white rounded-2xl p-6 shadow-lg">
            <div className="flex justify-between items-start mb-4">
              <Leaf className="w-8 h-8" />
            </div>
            <div className="text-4xl font-bold mb-1">{userStats.co2Saved} kg</div>
            <div className="text-green-100 mb-2">CO₂ Saved This Week</div>
            <div className="text-sm text-green-100">
              Equivalent to planting 0.6 trees! 🌳
            </div>
          </div>

          {/* Leaderboard Rank */}
          <div className="bg-gradient-to-br from-pink-500 to-pink-700 text-white rounded-2xl p-6 shadow-lg">
            <div className="flex justify-between items-start mb-4">
              <Trophy className="w-8 h-8" />
            </div>
            <div className="text-4xl font-bold mb-1">#{userStats.rank}</div>
            <div className="text-pink-100 mb-2">Company Rank</div>
            <div className="text-sm text-pink-100">
              You're in the top 10! Keep climbing! 🚀
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          {/* Log Trip Card */}
          <button
            onClick={() => onNavigate('trip')}
            className="bg-white rounded-2xl p-8 shadow-lg hover:shadow-xl transition-shadow text-left group"
          >
            <div className="flex items-center justify-between mb-4">
              <div className="bg-pink-100 w-16 h-16 rounded-full flex items-center justify-center group-hover:bg-pink-200 transition-colors">
                <QrCode className="w-8 h-8 text-pink-600" />
              </div>
              <div className="text-pink-600 font-semibold group-hover:translate-x-1 transition-transform">
                Scan Now →
              </div>
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-2">Log Your Trip</h3>
            <p className="text-gray-600">
              Scan QR code on your bus or train to earn instant points and track your impact
            </p>
            {userProfile?.preferPinkBus && (
              <div className="mt-4 flex items-center gap-2 text-pink-600">
                <Shield className="w-5 h-5" />
                <span className="text-sm font-semibold">Pink Bus preferred ✓</span>
              </div>
            )}
          </button>

          {/* Redeem Rewards Card */}
          <button
            onClick={() => onNavigate('rewards')}
            className="bg-gradient-to-br from-purple-600 to-pink-600 rounded-2xl p-8 shadow-lg hover:shadow-xl transition-shadow text-left text-white group"
          >
            <div className="flex items-center justify-between mb-4">
              <div className="bg-white/20 w-16 h-16 rounded-full flex items-center justify-center group-hover:bg-white/30 transition-colors">
                <Gift className="w-8 h-8 text-white" />
              </div>
              <div className="font-semibold group-hover:translate-x-1 transition-transform">
                View Rewards →
              </div>
            </div>
            <h3 className="text-2xl font-bold mb-2">Redeem Rewards</h3>
            <p className="text-purple-100">
              You have {userStats.totalPoints} points to spend on vouchers, free rides, and more!
            </p>
          </button>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Recent Trips */}
          <div className="lg:col-span-2 bg-white rounded-2xl p-6 shadow-lg">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-2xl font-bold text-gray-900">Recent Trips</h3>
              <button
                onClick={() => onNavigate('trip')}
                className="text-pink-600 font-semibold hover:text-pink-700"
              >
                View All
              </button>
            </div>
            <div className="space-y-4">
              {recentTrips.map((trip) => (
                <div
                  key={trip.id}
                  className="flex items-center justify-between p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    <div className="bg-pink-100 w-12 h-12 rounded-full flex items-center justify-center">
                      <Bus className="w-6 h-6 text-pink-600" />
                    </div>
                    <div>
                      <div className="font-semibold text-gray-900">{trip.mode}</div>
                      <div className="text-sm text-gray-600">{trip.date}</div>
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="font-bold text-green-600">+{trip.points} pts</div>
                    <div className="text-sm text-gray-600">{trip.co2}kg CO₂ saved</div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Leaderboard */}
          <div className="bg-white rounded-2xl p-6 shadow-lg">
            <div className="flex items-center gap-2 mb-6">
              <Trophy className="w-6 h-6 text-yellow-500" />
              <h3 className="text-2xl font-bold text-gray-900">Leaderboard</h3>
            </div>
            <div className="space-y-3">
              {leaderboard.map((user) => (
                <div
                  key={user.rank}
                  className={`flex items-center justify-between p-3 rounded-lg ${
                    user.isCurrentUser
                      ? 'bg-pink-50 border-2 border-pink-300'
                      : 'bg-gray-50'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <div className={`
                      w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold
                      ${user.rank === 1 ? 'bg-yellow-100 text-yellow-700' : ''}
                      ${user.rank === 2 ? 'bg-gray-200 text-gray-700' : ''}
                      ${user.rank === 3 ? 'bg-orange-100 text-orange-700' : ''}
                      ${user.rank > 3 ? 'bg-gray-100 text-gray-600' : ''}
                    `}>
                      {user.rank}
                    </div>
                    <div>
                      <div className="font-semibold text-gray-900 text-sm">
                        {user.name}
                      </div>
                    </div>
                  </div>
                  <div className="font-bold text-gray-700 text-sm">
                    {user.points} pts
                  </div>
                </div>
              ))}
            </div>
            <button className="w-full mt-4 py-3 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors font-semibold">
              View Full Leaderboard
            </button>
          </div>
        </div>

        {/* Achievements */}
        <div className="mt-6 bg-white rounded-2xl p-6 shadow-lg">
          <h3 className="text-2xl font-bold text-gray-900 mb-6">Achievements</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {achievements.map((achievement) => (
              <div
                key={achievement.id}
                className={`p-4 rounded-xl border-2 text-center ${
                  achievement.earned
                    ? 'border-yellow-400 bg-yellow-50'
                    : 'border-gray-200 bg-gray-50 opacity-60'
                }`}
              >
                <div className="text-4xl mb-2">{achievement.icon}</div>
                <div className="font-bold text-gray-900 text-sm mb-1">
                  {achievement.title}
                </div>
                <div className="text-xs text-gray-600">{achievement.description}</div>
                {achievement.earned && (
                  <div className="mt-2 text-yellow-600 font-semibold text-xs">✓ Earned</div>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
