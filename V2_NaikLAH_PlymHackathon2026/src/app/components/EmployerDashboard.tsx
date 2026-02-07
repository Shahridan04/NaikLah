import { useState } from 'react';
import { 
  ArrowLeft,
  Users, 
  TrendingUp, 
  Leaf, 
  DollarSign,
  Calendar,
  Award,
  Building2,
  Download,
  Filter
} from 'lucide-react';
import { LineChart, Line, BarChart, Bar, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

interface EmployerDashboardProps {
  onNavigate: (view: string) => void;
}

export default function EmployerDashboard({ onNavigate }: EmployerDashboardProps) {
  const [timeRange, setTimeRange] = useState('month');

  // Mock employer data
  const stats = {
    totalEmployees: 450,
    activeUsers: 180,
    participationRate: 40,
    co2Saved: 8200,
    subsidyProvided: 15000,
    tripsThisMonth: 1240,
  };

  const weeklyData = [
    { week: 'Week 1', trips: 280, co2: 1850, users: 165 },
    { week: 'Week 2', trips: 295, co2: 1920, users: 172 },
    { week: 'Week 3', trips: 310, co2: 2100, users: 178 },
    { week: 'Week 4', trips: 355, co2: 2330, users: 180 },
  ];

  const transportModeData = [
    { name: 'Pink Bus', value: 45, color: '#ec4899' },
    { name: 'Regular Bus', value: 25, color: '#3b82f6' },
    { name: 'LRT/Train', value: 18, color: '#8b5cf6' },
    { name: 'Bicycle', value: 8, color: '#22c55e' },
    { name: 'Walking', value: 4, color: '#10b981' },
  ];

  const topUsers = [
    { rank: 1, name: 'Sarah Wong', department: 'Logistics', trips: 52, co2: 28.8, points: 2150 },
    { rank: 2, name: 'Aisha Rahman', department: 'Operations', trips: 48, co2: 26.2, points: 1980 },
    { rank: 3, name: 'Michelle Tan', department: 'Admin', trips: 45, co2: 24.5, points: 1750 },
    { rank: 4, name: 'David Lee', department: 'IT', trips: 42, co2: 22.1, points: 1450 },
    { rank: 5, name: 'Lisa Chen', department: 'HR', trips: 38, co2: 20.8, points: 1250 },
  ];

  const monthlyTrend = [
    { month: 'Jan', trips: 890, co2: 5800 },
    { month: 'Feb', trips: 1020, co2: 6400 },
    { month: 'Mar', trips: 1150, co2: 7200 },
    { month: 'Apr', trips: 1240, co2: 8200 },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-4">
              <button
                onClick={() => onNavigate('landing')}
                className="text-white hover:text-gray-200"
              >
                <ArrowLeft className="w-6 h-6" />
              </button>
              <div>
                <h1 className="text-3xl font-bold">Employer Dashboard</h1>
                <p className="text-blue-100">PKT Logistics - Sustainable Transport Analytics</p>
              </div>
            </div>
            <div className="flex gap-3">
              <select
                value={timeRange}
                onChange={(e) => setTimeRange(e.target.value)}
                className="bg-white/20 text-white border border-white/30 px-4 py-2 rounded-lg backdrop-blur-sm font-semibold"
              >
                <option value="week" className="text-gray-900">This Week</option>
                <option value="month" className="text-gray-900">This Month</option>
                <option value="quarter" className="text-gray-900">This Quarter</option>
                <option value="year" className="text-gray-900">This Year</option>
              </select>
              <button className="bg-white/20 hover:bg-white/30 px-6 py-2 rounded-lg backdrop-blur-sm border border-white/30 font-semibold transition-colors flex items-center gap-2">
                <Download className="w-5 h-5" />
                Export Report
              </button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Key Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="bg-white rounded-xl p-6 shadow-md">
            <div className="flex items-center justify-between mb-4">
              <div className="bg-blue-100 w-12 h-12 rounded-lg flex items-center justify-center">
                <Users className="w-6 h-6 text-blue-600" />
              </div>
              <TrendingUp className="w-5 h-5 text-green-600" />
            </div>
            <div className="text-3xl font-bold text-gray-900 mb-1">
              {stats.activeUsers}/{stats.totalEmployees}
            </div>
            <div className="text-gray-600 mb-2">Active Participants</div>
            <div className="flex items-center gap-2">
              <div className="flex-1 bg-gray-200 rounded-full h-2">
                <div 
                  className="bg-blue-600 rounded-full h-2"
                  style={{ width: `${stats.participationRate}%` }}
                />
              </div>
              <span className="text-sm font-semibold text-blue-600">{stats.participationRate}%</span>
            </div>
          </div>

          <div className="bg-white rounded-xl p-6 shadow-md">
            <div className="flex items-center justify-between mb-4">
              <div className="bg-green-100 w-12 h-12 rounded-lg flex items-center justify-center">
                <Leaf className="w-6 h-6 text-green-600" />
              </div>
              <span className="text-green-600 text-sm font-semibold">+15% vs last month</span>
            </div>
            <div className="text-3xl font-bold text-gray-900 mb-1">
              {stats.co2Saved.toLocaleString()} kg
            </div>
            <div className="text-gray-600 mb-2">CO₂ Saved This Month</div>
            <div className="text-sm text-gray-600">
              ≈ {Math.round(stats.co2Saved / 20)} trees planted 🌳
            </div>
          </div>

          <div className="bg-white rounded-xl p-6 shadow-md">
            <div className="flex items-center justify-between mb-4">
              <div className="bg-purple-100 w-12 h-12 rounded-lg flex items-center justify-center">
                <Calendar className="w-6 h-6 text-purple-600" />
              </div>
              <span className="text-purple-600 text-sm font-semibold">+12% vs last month</span>
            </div>
            <div className="text-3xl font-bold text-gray-900 mb-1">
              {stats.tripsThisMonth.toLocaleString()}
            </div>
            <div className="text-gray-600 mb-2">Sustainable Trips</div>
            <div className="text-sm text-gray-600">
              Avg. {Math.round(stats.tripsThisMonth / stats.activeUsers)} trips/employee
            </div>
          </div>

          <div className="bg-white rounded-xl p-6 shadow-md">
            <div className="flex items-center justify-between mb-4">
              <div className="bg-orange-100 w-12 h-12 rounded-lg flex items-center justify-center">
                <DollarSign className="w-6 h-6 text-orange-600" />
              </div>
              <span className="text-orange-600 text-sm font-semibold">ROI: 2.3x</span>
            </div>
            <div className="text-3xl font-bold text-gray-900 mb-1">
              RM {stats.subsidyProvided.toLocaleString()}
            </div>
            <div className="text-gray-600 mb-2">Subsidy Provided</div>
            <div className="text-sm text-gray-600">
              RM {Math.round(stats.subsidyProvided / stats.activeUsers)}/employee
            </div>
          </div>
        </div>

        {/* Charts Section */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          {/* Monthly Trend */}
          <div className="bg-white rounded-xl p-6 shadow-md">
            <h3 className="text-xl font-bold text-gray-900 mb-6">Monthly Growth Trend</h3>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={monthlyTrend}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis yAxisId="left" />
                <YAxis yAxisId="right" orientation="right" />
                <Tooltip />
                <Legend />
                <Line yAxisId="left" type="monotone" dataKey="trips" stroke="#8b5cf6" strokeWidth={2} name="Total Trips" />
                <Line yAxisId="right" type="monotone" dataKey="co2" stroke="#22c55e" strokeWidth={2} name="CO₂ Saved (kg)" />
              </LineChart>
            </ResponsiveContainer>
          </div>

          {/* Transport Mode Distribution */}
          <div className="bg-white rounded-xl p-6 shadow-md">
            <h3 className="text-xl font-bold text-gray-900 mb-6">Transport Mode Distribution</h3>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={transportModeData}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                  outerRadius={100}
                  fill="#8884d8"
                  dataKey="value"
                >
                  {transportModeData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>

          {/* Weekly Progress */}
          <div className="bg-white rounded-xl p-6 shadow-md lg:col-span-2">
            <h3 className="text-xl font-bold text-gray-900 mb-6">Weekly Progress</h3>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={weeklyData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="week" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="trips" fill="#3b82f6" name="Total Trips" />
                <Bar dataKey="users" fill="#ec4899" name="Active Users" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Top Performers */}
        <div className="bg-white rounded-xl p-6 shadow-md mb-8">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-bold text-gray-900">Top Performing Employees</h3>
            <button className="text-blue-600 hover:text-blue-700 font-semibold flex items-center gap-1">
              View All
              <Award className="w-5 h-5" />
            </button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Rank</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Employee</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Department</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Trips</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">CO₂ Saved</th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Points</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {topUsers.map((user) => (
                  <tr key={user.rank} className="hover:bg-gray-50">
                    <td className="px-6 py-4">
                      <div className={`
                        w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm
                        ${user.rank === 1 ? 'bg-yellow-100 text-yellow-700' : ''}
                        ${user.rank === 2 ? 'bg-gray-200 text-gray-700' : ''}
                        ${user.rank === 3 ? 'bg-orange-100 text-orange-700' : ''}
                        ${user.rank > 3 ? 'bg-gray-100 text-gray-600' : ''}
                      `}>
                        {user.rank}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="font-semibold text-gray-900">{user.name}</div>
                    </td>
                    <td className="px-6 py-4 text-gray-600">{user.department}</td>
                    <td className="px-6 py-4">
                      <span className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-sm font-semibold">
                        {user.trips}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <span className="bg-green-100 text-green-700 px-3 py-1 rounded-full text-sm font-semibold">
                        {user.co2} kg
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <span className="text-purple-600 font-bold">{user.points} pts</span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Impact Summary */}
        <div className="grid md:grid-cols-2 gap-6">
          {/* Environmental Impact */}
          <div className="bg-gradient-to-br from-green-50 to-emerald-100 rounded-xl p-6 shadow-md">
            <div className="flex items-center gap-3 mb-4">
              <Leaf className="w-8 h-8 text-green-600" />
              <h3 className="text-xl font-bold text-gray-900">Environmental Impact</h3>
            </div>
            <div className="space-y-4">
              <div>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-gray-700">CO₂ Reduction Target</span>
                  <span className="font-bold text-gray-900">82%</span>
                </div>
                <div className="bg-white/50 rounded-full h-3">
                  <div className="bg-green-600 rounded-full h-3" style={{ width: '82%' }}></div>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4 pt-4">
                <div className="bg-white/50 rounded-lg p-3">
                  <p className="text-2xl font-bold text-green-700">410</p>
                  <p className="text-sm text-gray-700">Trees Equivalent</p>
                </div>
                <div className="bg-white/50 rounded-lg p-3">
                  <p className="text-2xl font-bold text-green-700">15,200</p>
                  <p className="text-sm text-gray-700">km Not Driven</p>
                </div>
              </div>
            </div>
          </div>

          {/* Business Impact */}
          <div className="bg-gradient-to-br from-blue-50 to-purple-100 rounded-xl p-6 shadow-md">
            <div className="flex items-center gap-3 mb-4">
              <Building2 className="w-8 h-8 text-blue-600" />
              <h3 className="text-xl font-bold text-gray-900">Business Impact</h3>
            </div>
            <div className="space-y-4">
              <div className="bg-white/50 rounded-lg p-4">
                <p className="text-sm text-gray-700 mb-1">Employee Satisfaction</p>
                <p className="text-3xl font-bold text-blue-700">+28%</p>
              </div>
              <div className="bg-white/50 rounded-lg p-4">
                <p className="text-sm text-gray-700 mb-1">Parking Cost Savings</p>
                <p className="text-3xl font-bold text-blue-700">RM 12,500</p>
              </div>
              <div className="bg-white/50 rounded-lg p-4">
                <p className="text-sm text-gray-700 mb-1">CSR Rating Improvement</p>
                <p className="text-3xl font-bold text-blue-700">+3.2 pts</p>
              </div>
            </div>
          </div>
        </div>

        {/* Call to Action */}
        <div className="mt-8 bg-gradient-to-r from-pink-600 to-purple-600 rounded-2xl p-8 text-white text-center">
          <h3 className="text-2xl font-bold mb-3">Want to increase participation?</h3>
          <p className="text-pink-100 mb-6 max-w-2xl mx-auto">
            We can help you design custom incentive programs and integrate Pink Bus routes for your employees. 
            45% of your active users already prefer women-only transport options.
          </p>
          <button className="bg-white text-purple-600 px-8 py-3 rounded-lg hover:bg-gray-100 transition-colors font-semibold">
            Schedule Consultation
          </button>
        </div>
      </div>
    </div>
  );
}
