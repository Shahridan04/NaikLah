import { useState } from 'react';
import { 
  QrCode, 
  ArrowLeft, 
  Bus, 
  Train, 
  Bike, 
  Footprints, 
  Car,
  Shield,
  MapPin,
  Clock,
  Star,
  AlertCircle,
  CheckCircle,
  Navigation
} from 'lucide-react';

interface TripLoggingProps {
  userProfile: any;
  onNavigate: (view: string) => void;
}

export default function TripLogging({ userProfile, onNavigate }: TripLoggingProps) {
  const [selectedMode, setSelectedMode] = useState<string | null>(null);
  const [showScanner, setShowScanner] = useState(false);
  const [tripLogged, setTripLogged] = useState(false);
  const [filterWomenOnly, setFilterWomenOnly] = useState(userProfile?.preferPinkBus || false);

  const transportModes = [
    { 
      id: 'pink-bus', 
      name: 'Pink Bus', 
      icon: Bus, 
      points: 50, 
      co2: 0.8, 
      color: 'pink',
      womenOnly: true,
      description: 'Women-only with female drivers'
    },
    { 
      id: 'bus', 
      name: 'Regular Bus', 
      icon: Bus, 
      points: 45, 
      co2: 0.7, 
      color: 'blue',
      womenOnly: false,
      description: 'Public bus service'
    },
    { 
      id: 'train', 
      name: 'LRT/Train', 
      icon: Train, 
      points: 40, 
      co2: 0.6, 
      color: 'purple',
      womenOnly: false,
      description: 'Rail transport'
    },
    { 
      id: 'bicycle', 
      name: 'Bicycle', 
      icon: Bike, 
      points: 60, 
      co2: 0.0, 
      color: 'green',
      womenOnly: false,
      description: 'Zero emissions'
    },
    { 
      id: 'walking', 
      name: 'Walking', 
      icon: Footprints, 
      points: 30, 
      co2: 0.0, 
      color: 'emerald',
      womenOnly: false,
      description: 'Healthiest option'
    },
    { 
      id: 'carpool', 
      name: 'Carpool', 
      icon: Car, 
      points: 35, 
      co2: 0.4, 
      color: 'orange',
      womenOnly: false,
      description: 'Shared rides'
    },
  ];

  const availableRoutes = [
    {
      id: 1,
      name: 'Route A - City Center',
      type: 'Pink Bus',
      womenOnly: true,
      nextArrival: '5 mins',
      safetyRating: 4.9,
      features: ['Female Driver', 'GPS Tracked', 'CCTV', 'Emergency SOS']
    },
    {
      id: 2,
      name: 'Route B - Industrial Park',
      type: 'Pink Bus',
      womenOnly: true,
      nextArrival: '12 mins',
      safetyRating: 4.8,
      features: ['Female Driver', 'GPS Tracked', 'CCTV', 'Emergency SOS']
    },
    {
      id: 3,
      name: 'Route C - Shopping District',
      type: 'Regular Bus',
      womenOnly: false,
      nextArrival: '3 mins',
      safetyRating: 4.5,
      features: ['GPS Tracked', 'CCTV']
    },
    {
      id: 4,
      name: 'LRT Blue Line',
      type: 'Train',
      womenOnly: false,
      nextArrival: '8 mins',
      safetyRating: 4.6,
      features: ['Women-Only Cabin Available', 'CCTV']
    },
  ];

  const filteredRoutes = filterWomenOnly 
    ? availableRoutes.filter(route => route.womenOnly)
    : availableRoutes;

  const handleScanQR = (mode: string) => {
    setSelectedMode(mode);
    setShowScanner(true);
    // Simulate QR scan after 2 seconds
    setTimeout(() => {
      setShowScanner(false);
      setTripLogged(true);
      setTimeout(() => {
        onNavigate('dashboard');
      }, 3000);
    }, 2000);
  };

  if (tripLogged) {
    const mode = transportModes.find(m => m.id === selectedMode);
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center px-4">
        <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-8 text-center">
          <div className="bg-green-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6 animate-bounce">
            <CheckCircle className="w-12 h-12 text-green-600" />
          </div>
          <h2 className="text-3xl font-bold text-gray-900 mb-4">Trip Logged! 🎉</h2>
          <p className="text-gray-600 mb-6">
            Great job taking sustainable transport!
          </p>
          <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-xl p-6 mb-6">
            <div className="text-4xl font-bold text-purple-600 mb-2">
              +{mode?.points} Points
            </div>
            <div className="text-gray-700 mb-4">
              {mode?.co2}kg CO₂ saved
            </div>
            <div className="flex items-center justify-center gap-2 text-orange-600">
              <Star className="w-5 h-5 fill-orange-600" />
              <span className="font-semibold">10-day streak maintained!</span>
            </div>
          </div>
          <p className="text-sm text-gray-600">
            Redirecting to dashboard...
          </p>
        </div>
      </div>
    );
  }

  if (showScanner) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center px-4">
        <div className="max-w-md w-full">
          <div className="bg-white rounded-t-2xl p-6 text-center">
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Scanning QR Code</h2>
            <p className="text-gray-600">Point your camera at the QR code</p>
          </div>
          <div className="bg-gray-800 aspect-square relative flex items-center justify-center">
            {/* QR Scanner Frame */}
            <div className="absolute inset-8 border-4 border-pink-500 rounded-2xl">
              <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-pink-500 -mt-1 -ml-1"></div>
              <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-pink-500 -mt-1 -mr-1"></div>
              <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-pink-500 -mb-1 -ml-1"></div>
              <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-pink-500 -mb-1 -mr-1"></div>
              
              {/* Scanning line animation */}
              <div className="absolute inset-x-0 h-1 bg-pink-500 shadow-lg shadow-pink-500/50 animate-pulse" 
                   style={{ 
                     animation: 'scan 2s ease-in-out infinite',
                     top: '50%'
                   }}>
              </div>
            </div>
            <QrCode className="w-24 h-24 text-white opacity-30" />
          </div>
          <div className="bg-white rounded-b-2xl p-6 text-center">
            <div className="flex items-center justify-center gap-2 text-gray-600 mb-4">
              <div className="w-2 h-2 bg-pink-500 rounded-full animate-pulse"></div>
              <span>Scanning...</span>
            </div>
            <button
              onClick={() => setShowScanner(false)}
              className="text-gray-600 hover:text-gray-900 font-semibold"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center gap-4">
            <button
              onClick={() => onNavigate('dashboard')}
              className="text-gray-600 hover:text-gray-900"
            >
              <ArrowLeft className="w-6 h-6" />
            </button>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Log Your Trip</h1>
              <p className="text-gray-600">Choose your transport mode and start earning</p>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Women-Only Filter */}
        {userProfile?.preferPinkBus && (
          <div className="bg-pink-50 border-2 border-pink-200 rounded-xl p-4 mb-6 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Shield className="w-6 h-6 text-pink-600" />
              <div>
                <h3 className="font-bold text-gray-900">Women-Only Filter</h3>
                <p className="text-sm text-gray-600">Show only women-only transport options</p>
              </div>
            </div>
            <label className="relative inline-flex items-center cursor-pointer">
              <input
                type="checkbox"
                checked={filterWomenOnly}
                onChange={(e) => setFilterWomenOnly(e.target.checked)}
                className="sr-only peer"
              />
              <div className="w-11 h-6 bg-gray-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-pink-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-pink-600"></div>
            </label>
          </div>
        )}

        {/* Transport Mode Selection */}
        <div className="mb-8">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Select Transport Mode</h2>
          <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
            {transportModes.map((mode) => {
              const Icon = mode.icon;
              const isFiltered = filterWomenOnly && !mode.womenOnly;
              
              if (isFiltered) return null;

              return (
                <button
                  key={mode.id}
                  onClick={() => handleScanQR(mode.id)}
                  className={`
                    relative p-6 rounded-xl border-2 transition-all text-left
                    ${mode.womenOnly ? 'border-pink-300 bg-pink-50 hover:bg-pink-100' : 'border-gray-300 bg-white hover:bg-gray-50'}
                    hover:shadow-lg
                  `}
                >
                  {mode.womenOnly && (
                    <div className="absolute top-2 right-2 bg-pink-500 text-white px-2 py-1 rounded-full text-xs font-semibold flex items-center gap-1">
                      <Shield className="w-3 h-3" />
                      Women Only
                    </div>
                  )}
                  <div className={`
                    w-14 h-14 rounded-full flex items-center justify-center mb-4
                    ${mode.color === 'pink' ? 'bg-pink-200' : ''}
                    ${mode.color === 'blue' ? 'bg-blue-200' : ''}
                    ${mode.color === 'purple' ? 'bg-purple-200' : ''}
                    ${mode.color === 'green' ? 'bg-green-200' : ''}
                    ${mode.color === 'emerald' ? 'bg-emerald-200' : ''}
                    ${mode.color === 'orange' ? 'bg-orange-200' : ''}
                  `}>
                    <Icon className={`
                      w-7 h-7
                      ${mode.color === 'pink' ? 'text-pink-600' : ''}
                      ${mode.color === 'blue' ? 'text-blue-600' : ''}
                      ${mode.color === 'purple' ? 'text-purple-600' : ''}
                      ${mode.color === 'green' ? 'text-green-600' : ''}
                      ${mode.color === 'emerald' ? 'text-emerald-600' : ''}
                      ${mode.color === 'orange' ? 'text-orange-600' : ''}
                    `} />
                  </div>
                  <h3 className="text-lg font-bold text-gray-900 mb-1">{mode.name}</h3>
                  <p className="text-sm text-gray-600 mb-3">{mode.description}</p>
                  <div className="flex items-center justify-between text-sm">
                    <span className="font-bold text-green-600">+{mode.points} pts</span>
                    <span className="text-gray-600">{mode.co2}kg CO₂</span>
                  </div>
                </button>
              );
            })}
          </div>
        </div>

        {/* Available Routes */}
        <div>
          <h2 className="text-xl font-bold text-gray-900 mb-4">
            Available Routes Near You
          </h2>
          <div className="space-y-4">
            {filteredRoutes.map((route) => (
              <div
                key={route.id}
                className={`
                  bg-white rounded-xl p-6 shadow-md hover:shadow-lg transition-all
                  ${route.womenOnly ? 'border-2 border-pink-300' : ''}
                `}
              >
                <div className="flex items-start justify-between mb-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <h3 className="text-lg font-bold text-gray-900">{route.name}</h3>
                      {route.womenOnly && (
                        <span className="bg-pink-500 text-white px-2 py-1 rounded-full text-xs font-semibold flex items-center gap-1">
                          <Shield className="w-3 h-3" />
                          Women Only
                        </span>
                      )}
                    </div>
                    <p className="text-gray-600">{route.type}</p>
                  </div>
                  <div className="text-right">
                    <div className="flex items-center gap-1 text-yellow-600 mb-1">
                      <Star className="w-4 h-4 fill-yellow-600" />
                      <span className="font-semibold">{route.safetyRating}</span>
                    </div>
                    <p className="text-sm text-gray-600">Safety Rating</p>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4 mb-4">
                  <div className="flex items-center gap-2 text-gray-700">
                    <Clock className="w-5 h-5 text-blue-600" />
                    <div>
                      <p className="text-sm text-gray-600">Next Arrival</p>
                      <p className="font-semibold">{route.nextArrival}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2 text-gray-700">
                    <Navigation className="w-5 h-5 text-green-600" />
                    <div>
                      <p className="text-sm text-gray-600">Real-time</p>
                      <p className="font-semibold">GPS Tracked</p>
                    </div>
                  </div>
                </div>

                <div className="flex flex-wrap gap-2 mb-4">
                  {route.features.map((feature, index) => (
                    <span
                      key={index}
                      className="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-xs font-semibold"
                    >
                      {feature}
                    </span>
                  ))}
                </div>

                <button
                  onClick={() => handleScanQR(route.womenOnly ? 'pink-bus' : 'bus')}
                  className={`
                    w-full py-3 rounded-lg font-semibold transition-colors flex items-center justify-center gap-2
                    ${route.womenOnly 
                      ? 'bg-pink-600 text-white hover:bg-pink-700' 
                      : 'bg-gray-900 text-white hover:bg-gray-800'
                    }
                  `}
                >
                  <QrCode className="w-5 h-5" />
                  Scan QR Code to Board
                </button>
              </div>
            ))}
          </div>

          {filteredRoutes.length === 0 && (
            <div className="bg-yellow-50 border-2 border-yellow-200 rounded-xl p-8 text-center">
              <AlertCircle className="w-12 h-12 text-yellow-600 mx-auto mb-4" />
              <h3 className="text-lg font-bold text-gray-900 mb-2">
                No women-only routes available right now
              </h3>
              <p className="text-gray-600 mb-4">
                Try disabling the women-only filter to see all available routes
              </p>
              <button
                onClick={() => setFilterWomenOnly(false)}
                className="bg-pink-600 text-white px-6 py-3 rounded-lg hover:bg-pink-700 transition-colors font-semibold"
              >
                Show All Routes
              </button>
            </div>
          )}
        </div>

        {/* Manual Entry Option */}
        <div className="mt-8 bg-gray-100 rounded-xl p-6">
          <div className="flex items-start gap-4">
            <MapPin className="w-6 h-6 text-gray-600 flex-shrink-0 mt-1" />
            <div>
              <h3 className="font-bold text-gray-900 mb-2">Can't find a QR code?</h3>
              <p className="text-gray-600 mb-4">
                You can manually log your trip. We'll verify it through GPS tracking.
              </p>
              <button className="bg-white text-gray-700 px-6 py-2 rounded-lg hover:bg-gray-200 transition-colors font-semibold border-2 border-gray-300">
                Manual Entry
              </button>
            </div>
          </div>
        </div>
      </div>

      <style>{`
        @keyframes scan {
          0%, 100% { top: 10%; }
          50% { top: 90%; }
        }
      `}</style>
    </div>
  );
}
