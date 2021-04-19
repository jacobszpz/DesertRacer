/**
 * @file node.h
 * Container for an ISceneNode* with common operations involving vectors and position resetting
 *
 * @author Jacob Sanchez Perez (G20812080) <jsanchez-perez@uclan.ac.uk>
 * Games Concepts (CO1301), University of Central Lancashire
 */

#ifndef DESERT_RACER_NODE_H
#define DESERT_RACER_NODE_H

#include <TL-Engine.h>
#include "vector.h"


namespace desert
{
	// Model alignment in respect to an axis of the world
	enum NodeAlignment
	{
		xAligned,
		zAligned,
		Other
	};

	/**
	* Container for an ISceneNode* with common operations involving vectors and position resetting
	*/
	class SceneNodeContainer
	{
	public:
		static NodeAlignment getAlignmentFromRotation(int rotation);
		/**
		* @param sceneNode A TL-Engine ISceneNode pointer
		*/
		SceneNodeContainer(tle::ISceneNode* sceneNode);
		/**
		* @return The node's position in the three axis
		*/
		SVector3D position() const;
		/**
		* @return The node's position in the 2D plane
		*/
		SVector2D position2D() const;
		/**
		* @return The node's facing vector
		*/
		SVector3D getFacingVector() const;
		/**
		* @return The node's facing vector (only the x, z components)
		*/
		SVector2D getFacingVector2D() const;

		// Reset node's position to the one it had when the container was created
		void resetPosition(bool x = true, bool y = true, bool z = true);
		// Reset the node's local position to the one it had when the container was created
		void resetLocalPosition(bool x = true, bool y = true, bool z = true);
		
		// Node movement & local movement
		void moveByVector(SVector3D vector);
		void moveByVector(SVector2D vector);
		void moveLocallyByVector(SVector3D vector);
		void moveLocallyByVector(SVector2D vector);

		// Node rotation & local rotation
		void rotateByVector(SVector3D vector);
		void rotateByVector(SVector2D vector);
		void rotateLocallyByVector(SVector3D vector);
		void rotateLocallyByVector(SVector2D vector);

	protected:
		//
		static const int kAxisDegrees;
		// Store initial position and local position as vectors
		const SVector3D kInitialPosition, kInitialLocalPosition;

		// The pointer to the TL-Engine ISceneNode
		tle::ISceneNode* node;

	};

	/**
	* SceneNodeContainer that implements collision
	*/
	class CollisionModel : public SceneNodeContainer
	{
	public:
		CollisionModel(tle::IModel* m);
		/**
		* Checks if node of container has collided with a different node
		* @param position Vector containing position of other node
		* @param collisionRadius Optional parameter for cases in which sphere collision is implemented
		*/
		virtual bool collision(SVector2D position, const float collisionRadius = 0.0f) = 0;
	};

	// Interface for vector based movement
	class VectorBasedMovement
	{
	public:
		// Reverse movement vector
		virtual void bounce() = 0;
		// Move node by current movement vector
		virtual void applyMovementVector() = 0;
	protected:
		// Store movement vector
		SVector2D movementThisFrame;
	};
}

#endif