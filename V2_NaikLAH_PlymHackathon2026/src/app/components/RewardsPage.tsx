import { useState } from 'react';
import { 
  ArrowLeft, 
  Gift, 
  Star, 
  Coffee,
  ShoppingBag,
  Ticket,
  Bus,
  CheckCircle,
  Tag
} from 'lucide-react';

interface RewardsPageProps {
  userProfile: any;
  onNavigate: (view: string) => void;
}

export default function RewardsPage({ userProfile, onNavigate }: RewardsPageProps) {
  const [selectedReward, setSelectedReward] = useState<any>(null);
  const [showRedeemModal, setShowRedeemModal] = useState(false);
  const [redeemed, setRedeemed] = useState(false);

  const userPoints = 1250; // Mock points

  const rewards = [
    {
      id: 1,
      name: 'RM5 Grab Voucher',
      points: 500,
      icon: '🚗',
      category: 'Transport',
      description: 'RM5 discount on your next Grab ride',
      available: 50,
      color: 'green'
    },
    {
      id: 2,
      name: 'Free Bus Ride',
      points: 300,
      icon: '🚌',
      category: 'Transport',
      description: 'One complimentary bus ride on any route',
      available: 100,
      color: 'blue'
    },
    {
      id: 3,
      name: 'Starbucks Coffee',
      points: 600,
      icon: '☕',
      category: 'Food & Beverage',
      description: 'Free tall-sized coffee at any Starbucks outlet',
      available: 30,
      color: 'brown'
    },
    {
      id: 4,
      name: 'Pink Bus Monthly Pass',
      points: 1200,
      icon: '💖',
      category: 'Transport',
      description: 'Unlimited Pink Bus rides for one month',
      available: 20,
      color: 'pink'
    },
    {
      id: 5,
      name: 'RM10 Shopping Voucher',
      points: 800,
      icon: '🛍️',
      category: 'Shopping',
      description: 'RM10 off at participating retail stores',
      available: 40,
      color: 'purple'
    },
    {
      id: 6,
      name: 'Cinema Ticket',
      points: 700,
      icon: '🎬',
      category: 'Entertainment',
      description: 'One movie ticket at selected cinemas',
      available: 25,
      color: 'red'
    },
    {
      id: 7,
      name: 'Gym Day Pass',
      points: 400,
      icon: '💪',
      category: 'Health',
      description: 'Full day access to partner fitness centers',
      available: 35,
      color: 'orange'
    },
    {
      id: 8,
      name: 'Book Voucher',
      points: 450,
      icon: '📚',
      category: 'Education',
      description: 'RM15 voucher at Popular bookstore',
      available: 45,
      color: 'indigo'
    },
  ];

  const recentRedemptions = [
    { id: 1, reward: 'Free Bus Ride', date: '2 days ago', points: 300 },
    { id: 2, reward: 'Starbucks Coffee', date: '1 week ago', points: 600 },
  ];

  const handleRedeem = (reward: any) => {
    setSelectedReward(reward);
    setShowRedeemModal(true);
  };

  const confirmRedeem = () => {
    setShowRedeemModal(false);
    setRedeemed(true);
    setTimeout(() => {
      setRedeemed(false);
      setSelectedReward(null);
    }, 3000);
  };

  if (redeemed && selectedReward) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50 flex items-center justify-center px-4">
        <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-8 text-center">
          <div className="bg-green-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6 animate-bounce">
            <CheckCircle className="w-12 h-12 text-green-600" />
          </div>
          <h2 className="text-3xl font-bold text-gray-900 mb-4">Redeemed! 🎉</h2>
          <div className="text-6xl mb-4">{selectedReward.icon}</div>
          <h3 className="text-xl font-bold text-gray-900 mb-2">{selectedReward.name}</h3>
          <div className="bg-gray-100 rounded-xl p-4 mb-6">
            <p className="text-2xl font-bold text-purple-600 mb-2">
              Redemption Code
            </p>
            <p className="text-3xl font-mono font-bold text-gray-900 tracking-wider">
              ECO-{Math.random().toString(36).substr(2, 6).toUpperCase()}
            </p>
          </div>
          <p className="text-sm text-gray-600 mb-6">
            Show this code at the partner outlet or use it in their app
          </p>
          <button
            onClick={() => {
              setRedeemed(false);
              setSelectedReward(null);
            }}
            className="w-full bg-pink-600 text-white py-3 rounded-lg hover:bg-pink-700 transition-colors font-semibold"
          >
            Back to Rewards
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-gradient-to-r from-purple-600 to-pink-600 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center gap-4 mb-6">
            <button
              onClick={() => onNavigate('dashboard')}
              className="text-white hover:text-gray-200"
            >
              <ArrowLeft className="w-6 h-6" />
            </button>
            <div>
              <h1 className="text-3xl font-bold">Rewards</h1>
              <p className="text-purple-100">Redeem your points for exciting rewards</p>
            </div>
          </div>

          {/* Points Balance */}
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-6 border border-white/30">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-purple-100 mb-1">Your Points Balance</p>
                <p className="text-5xl font-bold">{userPoints}</p>
              </div>
              <Star className="w-16 h-16 text-yellow-300" />
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Featured Rewards */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Featured Rewards</h2>
          <div className="grid md:grid-cols-2 gap-6">
            {rewards.slice(0, 2).map((reward) => (
              <div
                key={reward.id}
                className={`
                  bg-gradient-to-br rounded-2xl p-6 text-white shadow-lg
                  ${reward.color === 'green' ? 'from-green-500 to-emerald-600' : ''}
                  ${reward.color === 'blue' ? 'from-blue-500 to-blue-700' : ''}
                `}
              >
                <div className="flex items-start justify-between mb-4">
                  <div className="text-5xl">{reward.icon}</div>
                  <span className="bg-white/30 px-3 py-1 rounded-full text-sm font-semibold">
                    Featured
                  </span>
                </div>
                <h3 className="text-2xl font-bold mb-2">{reward.name}</h3>
                <p className="text-white/90 mb-4">{reward.description}</p>
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-3xl font-bold">{reward.points}</p>
                    <p className="text-white/80 text-sm">points</p>
                  </div>
                  <button
                    onClick={() => handleRedeem(reward)}
                    disabled={userPoints < reward.points}
                    className={`
                      px-6 py-3 rounded-lg font-semibold transition-colors
                      ${userPoints >= reward.points
                        ? 'bg-white text-gray-900 hover:bg-gray-100'
                        : 'bg-white/30 text-white/60 cursor-not-allowed'
                      }
                    `}
                  >
                    {userPoints >= reward.points ? 'Redeem' : 'Not Enough Points'}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* All Rewards */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">All Rewards</h2>
          <div className="grid md:grid-cols-3 gap-6">
            {rewards.slice(2).map((reward) => {
              const canAfford = userPoints >= reward.points;
              return (
                <div
                  key={reward.id}
                  className={`
                    bg-white rounded-xl p-6 shadow-md hover:shadow-lg transition-all
                    ${!canAfford ? 'opacity-60' : ''}
                  `}
                >
                  <div className="flex items-start justify-between mb-4">
                    <div className="text-4xl">{reward.icon}</div>
                    <Tag className="w-5 h-5 text-gray-400" />
                  </div>
                  <span className="inline-block bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-xs font-semibold mb-3">
                    {reward.category}
                  </span>
                  <h3 className="text-lg font-bold text-gray-900 mb-2">{reward.name}</h3>
                  <p className="text-sm text-gray-600 mb-4">{reward.description}</p>
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <p className="text-2xl font-bold text-purple-600">{reward.points}</p>
                      <p className="text-xs text-gray-600">points</p>
                    </div>
                    <div className="text-right">
                      <p className="text-sm font-semibold text-gray-900">{reward.available} left</p>
                      <p className="text-xs text-gray-600">available</p>
                    </div>
                  </div>
                  <button
                    onClick={() => handleRedeem(reward)}
                    disabled={!canAfford}
                    className={`
                      w-full py-3 rounded-lg font-semibold transition-colors
                      ${canAfford
                        ? 'bg-pink-600 text-white hover:bg-pink-700'
                        : 'bg-gray-200 text-gray-500 cursor-not-allowed'
                      }
                    `}
                  >
                    {canAfford ? 'Redeem' : `Need ${reward.points - userPoints} more pts`}
                  </button>
                </div>
              );
            })}
          </div>
        </div>

        {/* Recent Redemptions */}
        <div className="bg-white rounded-xl p-6 shadow-md">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Recent Redemptions</h2>
          <div className="space-y-3">
            {recentRedemptions.map((redemption) => (
              <div
                key={redemption.id}
                className="flex items-center justify-between p-4 bg-gray-50 rounded-lg"
              >
                <div className="flex items-center gap-3">
                  <Gift className="w-10 h-10 text-purple-600" />
                  <div>
                    <p className="font-semibold text-gray-900">{redemption.reward}</p>
                    <p className="text-sm text-gray-600">{redemption.date}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="font-bold text-purple-600">-{redemption.points} pts</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Partner Banner */}
        <div className="mt-8 bg-gradient-to-r from-blue-600 to-purple-600 rounded-2xl p-8 text-white text-center">
          <h3 className="text-2xl font-bold mb-2">More Rewards Coming Soon!</h3>
          <p className="text-blue-100 mb-4">
            We're partnering with more businesses to bring you even better rewards
          </p>
          <div className="flex flex-wrap justify-center gap-4 text-sm">
            <span className="bg-white/20 px-4 py-2 rounded-full">PKT Logistics</span>
            <span className="bg-white/20 px-4 py-2 rounded-full">Grab</span>
            <span className="bg-white/20 px-4 py-2 rounded-full">Starbucks</span>
            <span className="bg-white/20 px-4 py-2 rounded-full">Popular Bookstore</span>
          </div>
        </div>
      </div>

      {/* Redeem Confirmation Modal */}
      {showRedeemModal && selectedReward && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center px-4 z-50">
          <div className="bg-white rounded-2xl max-w-md w-full p-8">
            <div className="text-center mb-6">
              <div className="text-6xl mb-4">{selectedReward.icon}</div>
              <h3 className="text-2xl font-bold text-gray-900 mb-2">
                Confirm Redemption
              </h3>
              <p className="text-gray-600">{selectedReward.name}</p>
            </div>

            <div className="bg-gray-50 rounded-xl p-4 mb-6">
              <div className="flex items-center justify-between mb-2">
                <span className="text-gray-600">Cost</span>
                <span className="font-bold text-gray-900">{selectedReward.points} points</span>
              </div>
              <div className="flex items-center justify-between mb-2">
                <span className="text-gray-600">Current Balance</span>
                <span className="font-bold text-gray-900">{userPoints} points</span>
              </div>
              <div className="border-t border-gray-300 my-2"></div>
              <div className="flex items-center justify-between">
                <span className="font-semibold text-gray-900">After Redemption</span>
                <span className="font-bold text-purple-600">
                  {userPoints - selectedReward.points} points
                </span>
              </div>
            </div>

            <div className="flex gap-3">
              <button
                onClick={() => setShowRedeemModal(false)}
                className="flex-1 bg-gray-200 text-gray-700 py-3 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
              >
                Cancel
              </button>
              <button
                onClick={confirmRedeem}
                className="flex-1 bg-pink-600 text-white py-3 rounded-lg hover:bg-pink-700 transition-colors font-semibold"
              >
                Confirm
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
